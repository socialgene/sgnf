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
include { CRABHASH                          } from '../modules/local/crabhash.nf'
include { DOWNLOAD_NCBI                     } from '../modules/local/download_ncbi.nf'
include { FEATURE_TABLE_DOWNLOAD            } from '../modules/local/feature_table_download.nf'
include { HMMER_HMMSEARCH                   } from '../modules/local/hmmsearch.nf'
include { HMM_HASH                          } from '../modules/local/hmm_hash.nf'
include { HMM_TSV_PARSE                     } from '../modules/local/hmm_tsv_parse.nf'
include { MMSEQS2_EASYCLUSTER               } from '../modules/local/mmseqs2_easycluster.nf'
include { NEO4J_ADMIN_IMPORT                } from '../modules/local/neo4j_admin_import.nf'
include { NEO4J_HEADERS                     } from '../modules/local/neo4j_headers.nf'
include { PAIRED_OMICS                      } from '../modules/local/paired_omics.nf'
include { PARAMETER_EXPORT_FOR_NEO4J        } from '../modules/local/parameter_export_for_neo4j.nf'
include { PROCESS_GENBANK_FILES             } from '../modules/local/process_genbank_files.nf'
include { PROTEIN_FASTA_DOWNLOAD            } from '../modules/local/protein_fasta_download.nf'
include { REFSEQ_ASSEMBLY_TO_TAXID          } from '../modules/local/refseq_assembly_to_taxid.nf'
include { SEQKIT_SPLIT                      } from '../modules/local/seqkit/split/main.nf'
include { SEQKIT_RMDUP                      } from '../modules/local/seqkit/rmdup/main.nf'
include { NCBI_DATASETS_DOWNLOAD            } from "../modules/local/ncbi_datasets_download.nf"

/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/


include { DOWNLOAD_AND_GATHER } from "../subworkflows/local/download_and_gather.nf"
include { LOCAL               } from '../subworkflows/local/inputs.nf'
include { NCBI                } from '../subworkflows/local/inputs.nf'
include { GATHER_HMMS          } from '../subworkflows/local/hmm_models.nf'



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

    PARAMETER_EXPORT_FOR_NEO4J()

    DOWNLOAD_NCBI('txid201174[Organism]')

    fasta_input = DOWNLOAD_NCBI.out.fasta.buffer( size: 1000 )
    processed_genome_ch = Channel.fromPath( '/home/chase/sg/chtc/fasta')

    CRABHASH(processed_genome_ch, params.crabhash_path, params.crabhash_glob)

    SEQKIT_RMDUP(CRABHASH.out.fasta)

    GATHER_HMMS()

    HMM_HASH(
        GATHER_HMMS.out.hmms,
        params.hmm_splits
    )

    HMM_TSV_PARSE(
        HMM_HASH.out.all_hmms_tsv
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
