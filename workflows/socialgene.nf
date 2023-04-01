/*
========================================================================================
    VALIDATE INPUTS
========================================================================================
*/

def summary_params = NfcoreSchema.paramsSummaryMap(workflow, params)

// Validate input parameters
//          WorkflowSocialgene.initialise(params, log)

// Check input path parameters to see if they exist
//          def checkPathParamList = [ params.input, params.multiqc_config, params.fasta ]
//          for (param in checkPathParamList) { if (param) { file(param, checkIfExists: true) } }

// Check mandatory parameters
//          if (params.input) { ch_input = file(params.input) } else { exit 1, 'Input samplesheet not specified!' }

/*
========================================================================================
    IMPORT LOCAL MODULES
========================================================================================
*/
include { ANTISMASH                         } from '../modules/local/antismash/main'
include { ANTISMASH_GBK_TO_TABLE            } from '../modules/local/antismash/antismash_gbk_to_table'
include { MMSEQS2_EASYCLUSTER               } from '../modules/local/mmseqs2_easycluster'
include { MMSEQS2_CREATEDB                  } from '../modules/local/mmseqs2_createdb'
include { MMSEQS_CREATEINDEX                } from '../modules/nf-core/mmseqs/createindex/main'
include { NEO4J_ADMIN_IMPORT                } from '../modules/local/neo4j_admin_import'
include { NEO4J_ADMIN_IMPORT_DRYRUN         } from '../modules/local/neo4j_admin_import_dryrun'
include { NEO4J_HEADERS                     } from '../modules/local/neo4j_headers'
include { PARAMETER_EXPORT_FOR_NEO4J        } from '../modules/local/parameter_export_for_neo4j'
include { SEQKIT_SORT                       } from '../modules/local/seqkit/sort/main'
include { DEDUP_AND_INDEX                   } from '../modules/local/dedup_and_index'
include { SEQKIT_SPLIT                      } from '../modules/local/seqkit/split/main'
include { HTCONDOR_PREP                     } from '../modules/local/htcondor_prep'
include { HMMER_HMMSEARCH                   } from '../modules/local/hmmsearch'
include { HMMSEARCH_PARSE                   } from '../modules/local/hmmsearch_parse'
include { INDEX_FASTA                       } from '../modules/local/index_fasta'

include { DOWNLOAD_CHEMBL_DATA                       } from '../modules/local/download_chembl_data'



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
include { CUSTOM_DUMPSOFTWAREVERSIONS   } from '../modules/nf-core/custom/dumpsoftwareversions/main'
include { DIAMOND_BLASTP                } from '../modules/local/diamond/blastp/main'
include { DIAMOND_MAKEDB                } from '../modules/local/diamond/makedb/main'


/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

available_hmms=["antismash","amrfinder","bigslice","classiphage", "ipresto","pfam","prism","resfams","tigrfam","virus_orthologous_groups"]

workflow SOCIALGENE {
println "Manifest's pipeline version: $workflow.profile"
    ch_versions = Channel.empty()

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
            chembl_fasta_ch = DOWNLOAD_CHEMBL_DATA.out.chembl_31_fa
        } else {SG_MODULES
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

        // TODO: just pass this straight to DEDUP_AND_INDEX, dont' create a collected_fasta.faa.gz
        GENOME_HANDLING.out.ch_fasta.collect().set{ fasta_to_dedup}
        DEDUP_AND_INDEX(fasta_to_dedup)
        DEDUP_AND_INDEX.out
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

//            ch_split_fasta = single_ch_fasta.splitFasta(size:'15.MB', file:true, compress:true, decompress:true)

            } else {
                ch_split_fasta = single_ch_fasta
            }
            HMM_PREP(ch_split_fasta, hmmlist)
            if (params.htcondor){
                // collect all fasta and all hmms to pass to HTCONDOR_PREP
                // kept separate to control renaming files in the process
                ch_split_fasta.collect().set{all_split_fasta}
                HMM_PREP.out.hmms.collect().set{all_split_hmms}

                HTCONDOR_PREP(all_split_hmms, all_split_fasta)
                ch_versions = ch_versions.mix(HTCONDOR_PREP.out.versions)
                domtblout_ch = false
            } else if (params.domtblout_path){
                domtblout_ch = Channel.fromPath(params.domtblout_path)


            } else {
                // create a channel that's the cartesian product of all hmm files and all fasta files
                HMM_PREP.out.hmms
                    .flatten()
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
            hmmer_result_ch = HMMSEARCH_PARSE.out.parseddomtblout.collect()
            ch_versions = ch_versions.mix(HMMSEARCH_PARSE.out.versions.last())
        }

        hmm_tsv_parse_ch = HMM_PREP.out.hmm_tsv_nodes.concat(
            HMM_PREP.out.hmm_tsv_out
        ).collect()

        tigrfam_ch = HMM_PREP.out.tigr_ch.collect()

    } else {


        hmm_tsv_parse_ch =  file("${baseDir}/assets/EMPTY_FILE")
        tigrfam_ch =  file("${baseDir}/assets/EMPTY_FILE")
        hmmer_result_ch = file("${baseDir}/assets/EMPTY_FILE")
    }

    /*
    ////////////////////////
    ANTISMASH
    ////////////////////////
    */
    if (run_antismash){
        ANTISMASH(GENOME_HANDLING.out.ch_gbk)
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
        MMSEQS_CREATEINDEX(MMSEQS2_CREATEDB.out.mmseqs_database)

        MMSEQS2_EASYCLUSTER(single_ch_fasta)
        MMSEQS2_EASYCLUSTER.out.clusterres_cluster
            .collect()
            .set{mmseqs2_ch}
        ch_versions = ch_versions.mix(MMSEQS2_EASYCLUSTER.out.versions)
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
    BUILD NEO4J DATABASE
    ////////////////////////
    */
    // collected_version_files ensures everythin was run first
    collected_version_files = ch_versions.collectFile(name: 'temp.yml', newLine: true)

    // all the '.collect()'s were added to ensure a cardinality of 1 for all inputs to database build

    // NEO4J_ADMIN_IMPORT_DRYRUN(
    //     sg_modules,
    //     hmmlist
    // )

if (run_build_database) {

    // Neo4j isn't available with Conda so check that Docker is being used
    if (workflow.profile.contains("conda")){
        println '\033[0;34m The Neo4j database can only be built using the docker Nextflow profile, but you have used Conda. The Docker/Neo4j command to do build the database can be found at \n "$outdir/socialgene_neo4j/command_to_build_neo4j_database_with_docker.sh" \033[0m'
    } else if (workflow.profile.contains("docker")){
            NEO4J_ADMIN_IMPORT(
                sg_modules.collect(),
                hmmlist.collect(),
                neo4j_header_ch,
                taxdump_ch,
                hmm_tsv_parse_ch,
                blast_ch,
                mmseqs2_ch,
                hmmer_result_ch,
                tigrfam_ch,
                parameters_ch,
                GENOME_HANDLING.out.ch_genome_info,
                GENOME_HANDLING.out.ch_protein_info
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
        collected_version_files
    )

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
}

/*
========================================================================================
    THE END
========================================================================================
*/
