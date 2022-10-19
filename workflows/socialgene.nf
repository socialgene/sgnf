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

include { MMSEQS2_EASYCLUSTER               } from '../modules/local/mmseqs2_easycluster'
include { NEO4J_ADMIN_IMPORT                } from '../modules/local/neo4j_admin_import'
include { NEO4J_HEADERS                     } from '../modules/local/neo4j_headers'
include { PAIRED_OMICS                      } from '../modules/local/paired_omics'
include { PARAMETER_EXPORT_FOR_NEO4J        } from '../modules/local/parameter_export_for_neo4j'
include { SEQKIT_SORT                       } from '../modules/local/seqkit/sort/main'
include { SEQKIT_RMDUP                      } from '../modules/local/seqkit/rmdup/main.nf'
include { SEQKIT_SPLIT                      } from '../modules/local/seqkit/split/main'
include { HTCONDOR_PREP                     } from '../modules/local/htcondor_prep'
include { HMMER_HMMSEARCH                   } from '../modules/local/hmmsearch'
include { HMMSEARCH_PARSE                   } from '../modules/local/hmmsearch_parse'

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
include { ANTISMASH                     } from '../modules/local/antismash/main'


/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

available_hmms=["antismash","amrfinder","bigslice","classiphage","pfam","prism","resfams","tigrfam","virus_orthologous_groups"]

workflow SOCIALGENE {

    ch_versions = Channel.empty()

    def hmmlist = []
    // if not `null`, hmmlist needs to be a list
    if( params.hmmlist instanceof String ) {
        hmmlist.addAll([params.hmmlist])
    }
    else {
        hmmlist.addAll(params.hmmlist)
    }

    if (hmmlist.contains("all")) {
        hmmlist = available_hmms
    }

    if (params.custom_hmm_file) {
        hmmlist.addAll(["local"])
    }

    run_blastp = params.htcondor ? false : params.blastp
    run_mmseqs2 = params.htcondor ? false : params.mmseqs2
    run_ncbi_taxonomy = params.htcondor ? false : params.ncbi_taxonomy
    run_build_database = params.htcondor ? false : params.build_database

    SG_MODULES(hmmlist)

    sg_modules = SG_MODULES.out.sg_modules

    PARAMETER_EXPORT_FOR_NEO4J()

    /*
    ////////////////////////
    READ AND PROCESS INPUTS
    ////////////////////////
    */

    if (!params.sgnr_fasta){

        GENOME_HANDLING()
        GENOME_HANDLING.out.ch_fasta.set{ch_fasta}
        ch_versions = ch_versions.mix(GENOME_HANDLING.out.ch_versions)



        ANTISMASH(GENOME_HANDLING.out.ch_gbk)

        SEQKIT_RMDUP(ch_fasta)
        SEQKIT_RMDUP.out
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
    } else {
        single_ch_fasta = Channel.fromPath( params.sgnr_fasta)
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
