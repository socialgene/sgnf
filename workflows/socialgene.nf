/*
========================================================================================
    VALIDATE INPUTS
========================================================================================
*/

def summary_params = NfcoreSchema.paramsSummaryMap(workflow, params)



// Validate input parameters
WorkflowSocialgene.initialise(params, log)


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CONFIG FILES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

ch_multiqc_config          = Channel.fromPath("$projectDir/assets/multiqc_config.yml", checkIfExists: true)
ch_multiqc_custom_config   = params.multiqc_config ? Channel.fromPath( params.multiqc_config, checkIfExists: true ) : Channel.empty()
ch_multiqc_logo            = params.multiqc_logo   ? Channel.fromPath( params.multiqc_logo, checkIfExists: true ) : Channel.empty()
ch_multiqc_custom_methods_description = params.multiqc_methods_description ? file(params.multiqc_methods_description, checkIfExists: true) : file("$projectDir/assets/methods_description_template.yml", checkIfExists: true)

/*
========================================================================================
    IMPORT LOCAL MODULES
========================================================================================
*/
include { ANTISMASH                                     } from '../modules/local/antismash/main'
include { ANTISMASH_GBK_TO_TABLE                        } from '../modules/local/antismash/antismash_gbk_to_table'
include { DOWNLOAD_GOTERMS                              } from '../modules/local/download_goterms.nf'
include { MMSEQS2_CLUSTER                               } from '../modules/local/mmseqs2_cluster'
include { MMSEQS2_CREATEDB                              } from '../modules/local/mmseqs2_createdb'
include { NEO4J_ADMIN_IMPORT                            } from '../modules/local/neo4j_admin_import'
include { NEO4J_ADMIN_IMPORT_DRYRUN                     } from '../modules/local/neo4j_admin_import_dryrun'
include { NEO4J_HEADERS                                 } from '../modules/local/neo4j_headers'
include { PARAMETER_EXPORT_FOR_NEO4J                    } from '../modules/local/parameter_export_for_neo4j'
include { SEQKIT_SORT                                   } from '../modules/local/seqkit/sort/main'
include { DEDUPLICATE_AND_INDEX_FASTA                   } from '../modules/local/dedup_and_index'
include { SEQKIT_SPLIT                                  } from '../modules/local/seqkit/split/main'
include { HTCONDOR_PREP                                 } from '../modules/local/htcondor_prep'
include { HMMER_HMMSEARCH                               } from '../modules/local/hmmsearch'
include { HMMSEARCH_PARSE                               } from '../modules/local/hmmsearch_parse'
include { INDEX_FASTA                                   } from '../modules/local/index_fasta'
include { DOWNLOAD_CHEMBL_DATA                          } from '../modules/local/download_chembl_data'
include { MD5_AS_FILENAME as MERGE_PARSED_DOMTBLOUT   } from '../modules/local/md5_as_filename'



/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/

include { NCBI_TAXONOMY        } from '../subworkflows/local/ncbi_taxonomy'
include { GENOME_HANDLING           } from '../subworkflows/local/genome_handling'
include { SG_MODULES                } from '../subworkflows/local/sg_modules'
include { HMM_PREP                  } from '../subworkflows/local/hmm_prep'
//include { HMM_RUN                   } from '../subworkflows/local/hmm_run'
//include { HMM_OUTSOURCED            } from '../subworkflows/local/hmm_outsourced'

/*
========================================================================================
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
========================================================================================
*/
include { CUSTOM_DUMPSOFTWAREVERSIONS   } from '../modules/local/custom/dumpsoftwareversions/main'
include { DIAMOND_BLASTP                } from '../modules/local/diamond/blastp/main'
include { DIAMOND_MAKEDB                } from '../modules/local/diamond/makedb/main'
include { MULTIQC                       } from '../modules/local/multiqc/main'

/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

available_hmms=["antismash","amrfinder","bigslice","classiphage", "ipresto","pfam","prism","resfams","tigrfam","virus_orthologous_groups"]

// Info required for completion email and summary
def multiqc_report = []

workflow SOCIALGENE {

    println "Manifest's pipeline version: $workflow.profile"
    ch_versions = Channel.empty()
    ch_citations = Channel.empty()

    def hmmlist = []
    // if not `null`, hmmlist needs to be a list
    if( params.hmmlist instanceof String ) {
        hmmlist.addAll([params.hmmlist])
    } else {
        hmmlist.addAll(params.hmmlist)
    }

    if (hmmlist.contains("all")) {
        // TODO: Move available_hmms logic into socialgene python step to consolidate code
        hmmlist = available_hmms
    }

    if (params.custom_hmm_file) {
        hmmlist.addAll(["local"])
    }

    run_blastp = params.htcondor ? false : params.blastp
    run_mmseqs2 = params.htcondor ? false : params.mmseqs2
    run_ncbi_taxonomy = params.htcondor ? false : params.ncbi_taxonomy
    run_build_database = params.htcondor ? false : params.build_database
    run_antismash = params.htcondor ? false : params.antismash

    SG_MODULES(hmmlist)

    sg_modules = SG_MODULES.out.sg_modules

    PARAMETER_EXPORT_FOR_NEO4J()
    parameters_ch = PARAMETER_EXPORT_FOR_NEO4J.out.parameters.collect()



    /*
    ////////////////////////
    READ AND PROCESS INPUTS
    ////////////////////////
    */


    if (params.chembl) {
        // chembl has fasta we need to process, so download here and pass fasta along
        DOWNLOAD_CHEMBL_DATA()
        chembl_fasta_ch = DOWNLOAD_CHEMBL_DATA.out.chembl_fa
        ch_versions = ch_versions.mix(DOWNLOAD_CHEMBL_DATA.out.ch_versions)
    } else {
        chembl_fasta_ch = Channel.empty()
    }

    if (params.local_fasta){
        local_fasta_ch = Channel.fromPath(params.local_fasta)
    } else {
        local_fasta_ch = Channel.empty()
    }

    input_fasta_ch = chembl_fasta_ch.mix(local_fasta_ch)

    GENOME_HANDLING(input_fasta_ch)
    GENOME_HANDLING.out.ch_fasta.set{ch_fasta}
    ch_versions = ch_versions.mix(GENOME_HANDLING.out.ch_versions)

    // TODO: just pass this straight to DEDUPLICATE_AND_INDEX_FASTA, dont' create a collected_fasta.faa.gz
    GENOME_HANDLING.out.ch_fasta.collect().set{ fasta_to_dedup}
    DEDUPLICATE_AND_INDEX_FASTA(fasta_to_dedup)
    DEDUPLICATE_AND_INDEX_FASTA.out
        .fasta
        .set{ch_nr_fasta}

    if (params.sort_fasta) {
        // If testing, sort the FASTA file to get consistent output, otherwise skip
        // Use seqkit to remove redundant sequences, based on sequence id because they are already the sequence hash
        SEQKIT_SORT(ch_nr_fasta)
        SEQKIT_SORT.out
            .fasta
            .set{single_ch_fasta}
    } else {
        single_ch_fasta = ch_nr_fasta
    }

    /*
    ////////////////////////
    HMM ANNOTATION
    ////////////////////////
    */
    if (params.hmmlist || params.custom_hmm_file){


        if (params.fasta_splits > 1){
            SEQKIT_SPLIT(
                single_ch_fasta
                )
            SEQKIT_SPLIT
                .out
                .fasta
                .flatten()
                .set{ch_split_fasta}

        } else {
            ch_split_fasta = single_ch_fasta
        }

        HMM_PREP(hmmlist)

        // either
        // 1) collect files to send to high throughput computing (outside of nf-workflow)
        // 2) use path to domtblout file
        // 3) run HMMER using nextflow

        if (params.htcondor){
            // collect all fasta and all hmms to pass to HTCONDOR_PREP
            // kept separate to control renaming files in the process
            ch_split_fasta.collect().set{all_split_fasta}
            HTCONDOR_PREP(HMM_PREP.out.all_hmms, all_split_fasta)
            ch_versions = ch_versions.mix(HTCONDOR_PREP.out.versions)
            domtblout_ch = false
        } else if (params.domtblout_path){
            domtblout_ch = Channel.fromPath(params.domtblout_path)
        } else {
            // create a channel that's the cartesian product of all hmm files and all fasta files
            HMM_PREP.out.hmms_file_with_cutoffs.mix(HMM_PREP.out.hmms_file_without_cutoffs)
                .combine(
                    ch_split_fasta
                        .flatten()
                )
                .set{ mixed_hmm_fasta_ch }
            HMMER_HMMSEARCH(mixed_hmm_fasta_ch)
            ch_versions = ch_versions.mix(HMMER_HMMSEARCH.out.versions.last())
            domtblout_ch = HMMER_HMMSEARCH.out.domtblout
        }

        if (domtblout_ch){

            HMMSEARCH_PARSE(domtblout_ch.buffer( size: 50, remainder: true ))


            ch_parsed_domtblout_concat = HMMSEARCH_PARSE.out.parseddomtblout.collectFile(name: "parseddomtblout", sort: 'hash', cache: true)
            MERGE_PARSED_DOMTBLOUT(ch_parsed_domtblout_concat)
            hmmer_result_ch = MERGE_PARSED_DOMTBLOUT.out.outfile
            ch_versions = ch_versions.mix(HMMSEARCH_PARSE.out.versions.last())
        }

        hmm_info_ch = HMM_PREP.out.hmm_info
        hmm_nodes_ch = HMM_PREP.out.hmm_nodes


        tigrfam_ch = HMM_PREP.out.tigr_ch.collect()

    } else {

        hmm_info_ch =  file("${baseDir}/assets/EMPTY_FILE")
        hmm_nodes_ch =  file("${baseDir}/assets/EMPTY_FILE2")
        tigrfam_ch =  file("${baseDir}/assets/EMPTY_FILE")
        hmmer_result_ch = file("${baseDir}/assets/EMPTY_FILE")
    }

    /*
    ////////////////////////
    ANTISMASH
    ////////////////////////
    */
    if (run_antismash){
        ANTISMASH(GENOME_HANDLING.out.ch_non_mibig_gbk_file)
        ANTISMASH_GBK_TO_TABLE(ANTISMASH.out.regions_gbk.collect())
    }

    /*
    ////////////////////////
    BLASTP
    ////////////////////////
    */
    if (run_blastp){
        DIAMOND_MAKEDB(single_ch_fasta)
        DIAMOND_BLASTP(single_ch_fasta, DIAMOND_MAKEDB.out.db)
        DIAMOND_BLASTP.out.blastout
            .collect()
            .set{blast_ch}
        ch_versions = ch_versions.mix(DIAMOND_MAKEDB.out.versions)
        ch_versions = ch_versions.mix(DIAMOND_BLASTP.out.versions)
    } else {
        blast_ch = file("${baseDir}/assets/EMPTY_FILE")
    }

    /*
    ////////////////////////
    MMSEQS2
    ////////////////////////
    */
    if (run_mmseqs2){
        MMSEQS2_CREATEDB(single_ch_fasta)
        MMSEQS2_CLUSTER(MMSEQS2_CREATEDB.out.mmseqs_database, single_ch_fasta)
        MMSEQS2_CLUSTER.out.mmseqs_clustered_db_tsv
            .collect()
            .set{mmseqs2_ch}
        ch_versions = ch_versions.mix(MMSEQS2_CLUSTER.out.versions)
        ch_citations = ch_citations.mix(MMSEQS2_CLUSTER.out.citations)
    } else {
        mmseqs2_ch = file("${baseDir}/assets/EMPTY_FILE")
    }

    /*
    ////////////////////////
    TAXONOMY
    ////////////////////////
    */
    if (run_ncbi_taxonomy){
        NCBI_TAXONOMY()
        taxdump_ch = NCBI_TAXONOMY.out.taxid_to_taxid.concat(
                        NCBI_TAXONOMY.out.nodes_taxid
                        ).collect()
        ch_versions = ch_versions.mix(NCBI_TAXONOMY.out.versions)
    } else {
        taxdump_ch = file("${baseDir}/assets/EMPTY_FILE")
    }

    /*
    ////////////////////////
    NEO4J_HEADERS
    ////////////////////////
    */
    NEO4J_HEADERS(sg_modules, hmmlist)
    neo4j_header_ch = NEO4J_HEADERS.out.headers.collect()
    ch_versions = ch_versions.mix(NEO4J_HEADERS.out.versions)

    /*
    ////////////////////////
    GOTERMS
    ////////////////////////
    */

    if (sg_modules.contains("go")) {
        DOWNLOAD_GOTERMS()
        goterms_ch = DOWNLOAD_GOTERMS.out.goterm_nodes_edges
    } else {
        goterms_ch = file("${baseDir}/assets/EMPTY_FILE")
    }


    /*
    ////////////////////////
    BUILD NEO4J DATABASE
    ////////////////////////
    */
    // collected_version_files ensures everythin was run first

    // all the '.collect()'s were added to ensure a cardinality of 1 for all inputs to database build

    NEO4J_ADMIN_IMPORT_DRYRUN(
        sg_modules
    )

if (run_build_database) {

    // Neo4j isn't available with Conda so check that Docker is being used
    if (workflow.profile.contains("conda")){
        println '\033[0;34m The Neo4j database can only be built using the docker Nextflow profile, but you have used Conda. The Docker/Neo4j command to do build the database can be found at \n "$outdir/socialgene_neo4j/command_to_build_neo4j_database_with_docker.sh" \033[0m'
    } else if (workflow.profile.contains("docker")){

            // TODO: this is not good/fragile, it really should be a single tuple input, but will have
            // to recode admin import to not care about directory structure
            NEO4J_ADMIN_IMPORT(
                sg_modules.collect(),
                hmmlist.collect(),
                neo4j_header_ch,
                taxdump_ch,
                hmm_info_ch,
                hmm_nodes_ch,
                blast_ch,
                mmseqs2_ch,
                hmmer_result_ch,
                tigrfam_ch,
                parameters_ch,
                GENOME_HANDLING.out.ch_genome_info,
                GENOME_HANDLING.out.ch_protein_info,
                goterms_ch
            )

            ch_versions = ch_versions.mix(NEO4J_ADMIN_IMPORT.out.versions)
        }
    }


    /*
    ////////////////////////
    OUTPUT SOFTWARE VERSIONS
    ////////////////////////
    */

    CUSTOM_DUMPSOFTWAREVERSIONS (
        ch_versions.unique().collectFile(name: 'collated_versions.yml')
    )

    /*
    ////////////////////////
    MultiQC
    ////////////////////////
    */

    workflow_summary    = WorkflowSgnf.paramsSummaryMultiqc(workflow, summary_params)
    ch_workflow_summary = Channel.value(workflow_summary)

    methods_description    = WorkflowSgnf.methodsDescriptionText(workflow, ch_multiqc_custom_methods_description)
    ch_methods_description = Channel.value(methods_description)

    ch_multiqc_files = Channel.empty()
    ch_multiqc_files = ch_multiqc_files.mix(ch_workflow_summary.collectFile(name: 'workflow_summary_mqc.yaml'))
    ch_multiqc_files = ch_multiqc_files.mix(ch_methods_description.collectFile(name: 'methods_description_mqc.yaml'))
    ch_multiqc_files = ch_multiqc_files.mix(CUSTOM_DUMPSOFTWAREVERSIONS.out.mqc_yml.collect())

    MULTIQC (
        ch_multiqc_files.collect(),
        ch_multiqc_config.toList(),
        ch_multiqc_custom_config.toList(),
        ch_multiqc_logo.toList()
    )
    multiqc_report = MULTIQC.out.report.toList()

}

/*
========================================================================================
    COMPLETION EMAIL AND SUMMARY
========================================================================================
*/

workflow.onComplete {
    if (params.email || params.email_on_fail) {
        NfcoreTemplate.email(workflow, params, summary_params, projectDir, log, multiqc_report)
    }
    NfcoreTemplate.summary(workflow, params, log)
    if (params.hook_url) {
        NfcoreTemplate.IM_notification(workflow, params, summary_params, projectDir, log)
    }
}

/*
========================================================================================
    THE END
========================================================================================
*/
