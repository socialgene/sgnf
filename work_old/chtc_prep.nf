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

include { CRABHASH                                  } from '../modules/local/crabhash.nf'
include { DOWNLOAD_ALL_REFSEQ_GENOME_FEATURETABLES  } from "../modules/local/download_all_refseq_genome_featuretables.nf"
include { DOWNLOAD_REFSEQ_NONREDUNDANT_COMPLETE     } from "../modules/local/download_refseq_nonredundant_complete.nf"
include { FEATURE_TABLE_DOWNLOAD                    } from '../modules/local/feature_table_download.nf'
include { HMM_HASH                                  } from '../modules/local/hmm_hash.nf'
include { HMM_TSV_PARSE                             } from '../modules/local/hmm_tsv_parse.nf'
include { HMMSEARCH_PARSE                           } from '../modules/local/hmmsearch_parse.nf'
include { MMSEQS2_EASYCLUSTER                       } from '../modules/local/mmseqs2_easycluster.nf'
include { NEO4J_ADMIN_IMPORT                        } from '../modules/local/neo4j_admin_import.nf'
include { NEO4J_HEADERS                             } from '../modules/local/neo4j_headers.nf'
include { PARAMETER_EXPORT_FOR_NEO4J                } from '../modules/local/parameter_export_for_neo4j.nf'
include { PARSE_REFSEQ_ID_DESCRIPTIONS              } from '../modules/local/parse_refseq_id_descriptions.nf'
include { SEQKIT_SPLIT as FASTA_FILES_FOR_CHTC      } from '../modules/local/seqkit/split/main.nf'
include { NCBI_DATASETS_DOWNLOAD                    } from "../modules/local/ncbi_datasets_download.nf"



/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/



include { GATHER_HMMS               } from "../subworkflows/local/gather_hmms.nf"
include { NCBI_TAXONOMY        } from '../subworkflows/local/ncbi_taxonomy.nf'

include { TIGRFAM_INFO              } from '../subworkflows/local/tigrfam_info.nf'



//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//

/*
========================================================================================
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
========================================================================================
*/

//
// MODULE: Installed but modified from nf-core/modules
//
include { CUSTOM_DUMPSOFTWAREVERSIONS } from '../modules/nf-core/modules/custom/dumpsoftwareversions/main'
include { DIAMOND_MAKEDB      } from '../modules/local/diamond/makedb/main.nf'

/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

workflow CHTC_PREP {
    ch_versions = Channel.empty()
    PARAMETER_EXPORT_FOR_NEO4J()

    DOWNLOAD_REFSEQ_NONREDUNDANT_COMPLETE()

    CRABHASH(DOWNLOAD_REFSEQ_NONREDUNDANT_COMPLETE.out.fasta, params.crabhash_path, params.crabhash_glob)

    FASTA_FILES_FOR_CHTC(CRABHASH.out.fasta)

    GATHER_HMMS()
    ch_versions = ch_versions.mix(GATHER_HMMS.out.versions)

    HMM_HASH(
        GATHER_HMMS.out.hmms,
        params.hmm_splits
    )
    ch_versions = ch_versions.mix(HMM_HASH.out.versions)

    HMM_TSV_PARSE(
        HMM_HASH.out.all_hmms_tsv
    )
    ch_versions = ch_versions.mix(HMM_TSV_PARSE.out.versions)


    //DOWNLOAD_ALL_REFSEQ_GENOME_FEATURETABLES()

    PARSE_REFSEQ_ID_DESCRIPTIONS(DOWNLOAD_REFSEQ_NONREDUNDANT_COMPLETE.out.fasta)

    MMSEQS2_EASYCLUSTER(CRABHASH.out.fasta)
    DIAMOND_MAKEDB(CRABHASH.out.fasta)


    if (params.chtc_results_dir) {
        chtc_domtblout_files_ch = Channel.fromPath( "${params.chtc_results_dir}/*.domtblout.gz" ).buffer(size: 50)

        HMMSEARCH_PARSE(chtc_domtblout_files_ch)
        hmmer_result_ch = HMMSEARCH_PARSE.out.parseddomtblout.collect()

        outdir_neo4j_ch = Channel.fromPath( params.outdir_neo4j )

        sg_modules = "protein" + " " + "paramaters" + " " + "mmseqs2" + " " + "ncbi_taxonomy"  + " " + "hmms" + " " + "base_hmm"
        NCBI_TAXONOMY()
        TIGRFAM_INFO()

        NEO4J_HEADERS(sg_modules)
        MMSEQS2_EASYCLUSTER.out.clusterres_cluster
            .set{mmseqs2_ch}
        blast_ch = file( "dummy_file1.txt", checkIfExists: false )
        NEO4J_ADMIN_IMPORT(
            outdir_neo4j_ch,
            NEO4J_HEADERS.out.headers,
            hmmer_result_ch,
            blast_ch,
            mmseqs2_ch,
            sg_modules
        )

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
