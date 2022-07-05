/*
========================================================================================
    VALIDATE INPUTS
========================================================================================
*/

//def summary_params = NfcoreSchema.paramsSummaryMap(workflow, params)

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

include { ASSEMBLY_FTP_URLS                 } from '../modules/local/assembly_ftp_urls.nf'
include { FEATURE_TABLE_DOWNLOAD            } from '../modules/local/feature_table_download.nf'
include { HMM_HASH                          } from '../modules/local/hmm_hash.nf'
include { HMM_TSV_PARSE                     } from '../modules/local/hmm_tsv_parse.nf'
include { MMSEQS2                           } from '../modules/local/mmseqs2.nf'
include { NEO4J_ADMIN_IMPORT                } from '../modules/local/neo4j_admin_import.nf'
include { NEO4J_HEADERS                     } from '../modules/local/neo4j_headers.nf'
include { PARAMETER_EXPORT_FOR_NEO4J        } from '../modules/local/parameter_export_for_neo4j.nf'
include { PROTEIN_FASTA_DOWNLOAD            } from '../modules/local/protein_fasta_download.nf'
include { PROTHASH_SQLITE                   } from '../modules/local/prothash_sqlite.nf'
include { PYHMMER                           } from '../modules/local/pyhmmer.nf'
include { REFSEQ_ASSEMBLY_TO_TAXID          } from '../modules/local/refseq_assembly_to_taxid.nf'
include { SEQKIT_SPLIT                      } from '../modules/local/seqkit/split/main.nf'

/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/

include { DOWNLOAD_AND_GATHER       } from "../subworkflows/local/download_and_gather.nf"




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


/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/


include { CRABHASH            } from '../modules/local/crabhash.nf'

include { HMMER_HMMSEARCH     } from '../modules/local/hmmsearch.nf'



workflow REFSEQ {

    sg_modules = "protein"

  //  ASSEMBLY_FTP_URLS()

    PARAMETER_EXPORT_FOR_NEO4J()


  //  REFSEQ_ASSEMBLY_TO_TAXID()

    refseq_nr_protein_paths = Channel.fromPath(params.refseq_nr_protein_fasta_dir)
    //refseq_nr_protein_paths
    CRABHASH(refseq_nr_protein_paths, params.crabhash_path)

    CRABHASH.out.fasta
        .flatten()
        .set{ch_fasta}

    PROTHASH_SQLITE(CRABHASH.out.tsv)

    if (params.ncbi_taxonomy){
        sg_modules = sg_modules + " ncbi_taxonomy"
    }

    if (params.hmmer){

        DOWNLOAD_AND_GATHER()
        HMM_HASH(
            DOWNLOAD_AND_GATHER.out.hmms,
            params.hmm_splits
        )

        // make a channel that's the cartesian product of hmm model files and fasta files
        HMM_HASH.out.socialgene_hmms
            .flatten()
            .combine(
                ch_fasta
            )
            .set{ hmm_ch }

        HMMER_HMMSEARCH(hmm_ch)
        hmmer_result_ch = HMMER_HMMSEARCH.out.versions.collect()

        HMM_TSV_PARSE(
            HMM_HASH.out.all_hmms_tsv
        )

        sg_modules = sg_modules + " hmms"
    } else {
        hmmer_result_ch = file( "dummy_file3.txt", checkIfExists: false )
    }

    NEO4J_HEADERS(sg_modules)

    blast_ch = file( "dummy_file1.txt", checkIfExists: false )

    if (params.mmseqs2){
        MMSEQS2(single_ch_fasta)
        MMSEQS2.out.clusterres_cluster
            .set{mmseqs2_ch}
        sg_modules = sg_modules + " mmseqs2"
    } else {
        mmseqs2_ch = file( "dummy_file2.txt", checkIfExists: false )
    }

    if (params.ncbi_taxonomy){
        sg_modules = sg_modules + " ncbi_taxonomy"
    }

    if (params.build_database) {
        NEO4J_ADMIN_IMPORT(NEO4J_HEADERS.out.headers, hmmer_result_ch, blast_ch, mmseqs2_ch, sg_modules)
    }


    //
    // MODULE: Run FastQC
    //
    // FASTQC (
    //     INPUT_CHECK.out.reads
    // )
    // ch_versions = ch_versions.mix(FASTQC.out.versions.first())

//    CUSTOM_DUMPSOFTWAREVERSIONS (
//        ch_versions.unique().collectFile(name: 'collated_versions.yml')
//    )


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
