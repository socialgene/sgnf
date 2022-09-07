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
    CONFIG FILES
========================================================================================
*/

//          ch_multiqc_config        = file("$projectDir/assets/multiqc_config.yaml", checkIfExists: true)
//          ch_multiqc_custom_config = params.multiqc_config ? Channel.fromPath(params.multiqc_config) : Channel.empty()

/*
========================================================================================
    IMPORT LOCAL MODULES
========================================================================================
*/
include { ANTISMASH                         } from '../modules/local/antismash/main'
include { ASSEMBLY_FTP_URLS                 } from '../modules/local/assembly_ftp_urls'
include { FEATURE_TABLE_DOWNLOAD            } from '../modules/local/feature_table_download'
include { HMMER_HMMSEARCH                   } from '../modules/local/hmmsearch'
include { HMMSEARCH_PARSE                   } from '../modules/local/hmmsearch_parse'
include { HMM_HASH                          } from '../modules/local/hmm_hash'
include { HMM_TSV_PARSE                     } from '../modules/local/hmm_tsv_parse'
include { MMSEQS2_EASYCLUSTER               } from '../modules/local/mmseqs2_easycluster'
include { NCBI_DATASETS_DOWNLOAD            } from '../modules/local/ncbi_datasets_download'
include { NEO4J_ADMIN_IMPORT                } from '../modules/local/neo4j_admin_import'
include { NEO4J_HEADERS                     } from '../modules/local/neo4j_headers'
include { PAIRED_OMICS                      } from '../modules/local/paired_omics'
include { PARAMETER_EXPORT_FOR_NEO4J        } from '../modules/local/parameter_export_for_neo4j'
include { PROTEIN_FASTA_DOWNLOAD            } from '../modules/local/protein_fasta_download'
include { SEQKIT_SORT                       } from '../modules/local/seqkit/sort/main'
include { SEQKIT_SPLIT                      } from '../modules/local/seqkit/split/main'
include { SEQKIT_RMDUP                      } from '../modules/local/seqkit/rmdup/main.nf'
/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/

include { GATHER_HMMS               } from '../subworkflows/local/gather_hmms'
include { NCBI_TAXONOMY_INFO        } from '../subworkflows/local/ncbi_taxonomy_info'
include { PROCESS_GENBANK           } from '../subworkflows/local/process_genbank_input'
include { TIGRFAM_INFO              } from '../subworkflows/local/tigrfam_info'
include { PROCESS_FASTA_INPUT       } from '../subworkflows/local/process_fasta_input'

/*
========================================================================================
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
========================================================================================
*/

include { CUSTOM_DUMPSOFTWAREVERSIONS   } from '../modules/nf-core/modules/custom/dumpsoftwareversions/main'
include { DIAMOND_BLASTP                } from '../modules/local/diamond/blastp/main'
include { DIAMOND_MAKEDB                } from '../modules/local/diamond/makedb/main'

/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

workflow DB_CREATOR {

    ch_versions = Channel.empty()

    if( !(params.hmmlist instanceof String) ) {
        hmmlist = [params.hmmlist]
    }
    hmmlist = params.hmmlist.join(' ')

    // start with an empty sg_modules
    sg_modules = ""

    PARAMETER_EXPORT_FOR_NEO4J()

    if (params.paired_omics_json_path) {
        paired_omics_json_path = file(params.paired_omics_json_path)
        PAIRED_OMICS(paired_omics_json_path)
        sg_modules = sg_modules + " paired_omics"
        ch_versions = ch_versions.mix(PAIRED_OMICS.out.versions)
    }
    ch_read = Channel.empty()
    if (params.ncbi_genome_download_command || params.local_genbank || params.ncbi_datasets_command){
        sg_modules = sg_modules + "base"
        PROCESS_GENBANK()
        ch_versions = ch_versions.mix(PROCESS_GENBANK.out.versions)
        gbk_fasta_ch = PROCESS_GENBANK.out.fasta
    } else {
        gbk_fasta_ch = Channel.empty()
    }

    if (params.local_fasta){
        sg_modules = sg_modules + "protein"

        input_fasta_ch = Channel.fromPath(params.local_fasta)

        PROCESS_FASTA_INPUT(input_fasta_ch)
        fasta_fasta_ch = PROCESS_FASTA_INPUT.out.fasta
    } else {
        fasta_fasta_ch = Channel.empty()
    }


        ch_read.mix(gbk_fasta_ch, fasta_fasta_ch).collect().set{ch_fasta}


    SEQKIT_RMDUP(ch_fasta)

    if (params.testing) {
        SEQKIT_SORT(SEQKIT_RMDUP.out.fasta)
        SEQKIT_SORT.out
            .fasta
            .set{single_ch_fasta}
    } else {
        SEQKIT_RMDUP
            .out
            .fasta
            .set{single_ch_fasta}
    }
    SEQKIT_SPLIT(
        single_ch_fasta,
        params.fasta_splits
        )

    if (params.blastp){
        sg_modules = sg_modules + " blastp"
        DIAMOND_MAKEDB(single_ch_fasta)
        DIAMOND_BLASTP(single_ch_fasta, DIAMOND_MAKEDB.out.db)
        DIAMOND_BLASTP.out.blastout
            .collect()
            .set{blast_ch}
        ch_versions = ch_versions.mix(DIAMOND_MAKEDB.out.versions)
        ch_versions = ch_versions.mix(DIAMOND_BLASTP.out.versions)
    } else {
        blast_ch = file( "dummy_file1.txt", checkIfExists: false )
    }

    if (params.mmseqs2){
        MMSEQS2_EASYCLUSTER(single_ch_fasta)
        MMSEQS2_EASYCLUSTER.out.clusterres_cluster
            .set{mmseqs2_ch}
        sg_modules = sg_modules + " mmseqs2"
        ch_versions = ch_versions.mix(MMSEQS2_EASYCLUSTER.out.versions)
    } else {
        mmseqs2_ch = file( "dummy_file2.txt", checkIfExists: false )
    }

    if (params.paired_omics){
        sg_modules = sg_modules + " paired_omics"
    }

    if (params.ncbi_taxonomy){
        NCBI_TAXONOMY_INFO()
        sg_modules = sg_modules + " ncbi_taxonomy"
        ch_versions = ch_versions.mix(NCBI_TAXONOMY_INFO.out.versions)
    }

    if (params.hmmer){
        sg_modules = sg_modules + " hmms"
        GATHER_HMMS()
        ch_versions = ch_versions.mix(GATHER_HMMS.out.versions)
        if (params.hmmlist.contains("tigrfam")){
            sg_modules = sg_modules + " tigrfam"
            // download additional tigrfam info
            TIGRFAM_INFO()
            ch_versions = ch_versions.mix(TIGRFAM_INFO.out.versions)
            ch_versions = ch_versions.mix(TIGRFAM_INFO.out.versions)
        }
        HMM_HASH(
            GATHER_HMMS.out.hmms,
            params.hmm_splits
        )
        ch_versions = ch_versions.mix(HMM_HASH.out.versions)
        // make a channel that's the cartesian product of hmm model files and fasta files
        HMM_HASH.out.socialgene_hmms
            .flatten()
            .combine(
                SEQKIT_SPLIT.out.fasta.flatten()
            )
            .set{ hmm_ch }

        HMMER_HMMSEARCH(hmm_ch)
        ch_versions = ch_versions.mix(HMMER_HMMSEARCH.out.versions.first())

        HMMSEARCH_PARSE(HMMER_HMMSEARCH.out.domtblout)
        ch_versions = ch_versions.mix(HMMSEARCH_PARSE.out.versions.first())

        hmmer_result_ch = HMMSEARCH_PARSE.out.parseddomtblout.collect()

        HMM_TSV_PARSE(
            HMM_HASH.out.all_hmms_tsv
        )
        ch_versions = ch_versions.mix(HMM_TSV_PARSE.out.versions)
    } else {
        hmmer_result_ch = file( "dummy_file3.txt", checkIfExists: false )
    }

    NEO4J_HEADERS(sg_modules)
    ch_versions = ch_versions.mix(NEO4J_HEADERS.out.versions)

    outdir_neo4j_ch = Channel.fromPath(params.outdir_neo4j)

    collected_version_files = ch_versions.collectFile(name: 'temp.yml', newLine: true)
    CUSTOM_DUMPSOFTWAREVERSIONS (
        collected_version_files
    )
       if (params.build_database) {
        NEO4J_ADMIN_IMPORT(
            outdir_neo4j_ch,
            sg_modules,
            hmmlist,
            collected_version_files
        )
        ch_versions = ch_versions.mix(NEO4J_ADMIN_IMPORT.out.versions)
    }
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
