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

include { CRABHASH                              } from '../modules/local/crabhash.nf'
include { FEATURE_TABLE_DOWNLOAD                } from '../modules/local/feature_table_download.nf'
include { HMM_HASH                              } from '../modules/local/hmm_hash.nf'
include { HMM_TSV_PARSE                         } from '../modules/local/hmm_tsv_parse.nf'
include { PARAMETER_EXPORT_FOR_NEO4J            } from '../modules/local/parameter_export_for_neo4j.nf'
include { SEQKIT_SPLIT                          } from '../modules/local/seqkit/split/main.nf'
include { NCBI_DATASETS_DOWNLOAD                } from "../modules/local/ncbi_datasets_download.nf"

include { DOWNLOAD_REFSEQ_NONREDUNDANT_COMPLETE } from "../modules/local/download_refseq_nonredundant_complete.nf"




/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/



include { GATHER_HMMS               } from "../subworkflows/local/gather_hmms.nf"



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
include { DIAMOND_BLASTP      } from '../modules/local/diamond/blastp/main.nf'
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
