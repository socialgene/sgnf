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

include { ANTISMASH                         } from '../modules/local/antismash/main.nf'
include { ASSEMBLY_FTP_URLS                 } from '../modules/local/assembly_ftp_urls.nf'
include { FEATURE_TABLE_DOWNLOAD            } from '../modules/local/feature_table_download.nf'
include { HMMER_HMMSEARCH                   } from '../modules/local/hmmsearch.nf'
include { HMM_HASH                          } from '../modules/local/hmm_hash.nf'
include { HMM_TSV_PARSE                     } from '../modules/local/hmm_tsv_parse.nf'
include { MMSEQS2                           } from '../modules/local/mmseqs2.nf'
include { NEO4J_ADMIN_IMPORT                } from '../modules/local/neo4j_admin_import.nf'
include { NEO4J_HEADERS                     } from '../modules/local/neo4j_headers.nf'
include { PAIRED_OMICS                      } from '../modules/local/paired_omics.nf'
include { PARAMETER_EXPORT_FOR_NEO4J        } from '../modules/local/parameter_export_for_neo4j.nf'
include { PROCESS_GENBANK_FILES             } from '../modules/local/process_genbank_files.nf'
include { PROTEIN_HASH                      } from '../modules/local/protein_hash.nf'
include { PROTEIN_FASTA_DOWNLOAD            } from '../modules/local/protein_fasta_download.nf'
include { PYHMMER                           } from '../modules/local/pyhmmer.nf'
include { REFSEQ_ASSEMBLY_TO_TAXID          } from '../modules/local/refseq_assembly_to_taxid.nf'
include { SEQKIT_SPLIT                      } from '../modules/local/seqkit/split/main.nf'

include { NCBI_DATASETS_DOWNLOAD_TAXON      } from "../modules/local/ncbi_datasets_download_taxon.nf"

/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/


include { DOWNLOAD_AND_GATHER       } from "../subworkflows/local/download_and_gather.nf"
//include { PARSE_FEATURE_TABLES      } from '../subworkflows/local/feature_table_parse.nf'
include { LOCAL                      } from '../subworkflows/local/inputs.nf'
include { NCBI                      } from '../subworkflows/local/inputs.nf'



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

workflow DB_CREATOR {

    sg_modules = "base"
    PARAMETER_EXPORT_FOR_NEO4J()

    if (params.ncbi_genome_download_command){
        NCBI()
        NCBI.out.gb_files.set{gb_files}
    } else if (params.gbk_input) {
        LOCAL()
        LOCAL.out.set{gb_files}
    }

    if (params.sequence_files_glob) {
        sequence_files_glob = params.sequence_files_glob
    } else {
        sequence_files_glob = "*.gbff.gz"
    }
    PROCESS_GENBANK_FILES(
        gb_files,
        params.fasta_splits,
        sequence_files_glob
    )

    PROCESS_GENBANK_FILES.out.fasta
        .flatten()
        .set{ch_fasta}

    ch_fasta
        .set{single_ch_fasta}

    if (params.hmms){

        DOWNLOAD_AND_GATHER()
        HMM_HASH(
            DOWNLOAD_AND_GATHER.out.hmms,
            params.hmm_splits
        )

        HMM_TSV_PARSE(
            HMM_HASH.out.all_hmms_tsv
        )

        sg_modules = sg_modules + " hmms"
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
