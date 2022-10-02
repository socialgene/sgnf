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
include { HTCONDOR1                         } from '../modules/local/htcondor'

/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/

include { NCBI_TAXONOMY_INFO        } from '../subworkflows/local/ncbi_taxonomy_info'
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

include { CUSTOM_DUMPSOFTWAREVERSIONS   } from '../modules/nf-core/modules/custom/dumpsoftwareversions/main'
include { DIAMOND_BLASTP                } from '../modules/local/diamond/blastp/main'
include { DIAMOND_MAKEDB                } from '../modules/local/diamond/makedb/main'

/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

workflow SOCIALGENE {

    ch_versions = Channel.empty()

    // if not `null`, hmmlist needs to be a list
    if( params.hmmlist instanceof String ) {
        hmmlist = [params.hmmlist]
    }
    else {
        hmmlist = params.hmmlist
    }

    SG_MODULES(hmmlist)

    sg_modules = SG_MODULES.out.sg_modules

    PARAMETER_EXPORT_FOR_NEO4J()

    /*
    ////////////////////////
    READ AND PROCESS INPUTS
    ////////////////////////
    */

    GENOME_HANDLING()

    GENOME_HANDLING.out.ch_fasta.set{ch_fasta}
    ch_versions = ch_versions.mix(GENOME_HANDLING.out.ch_versions)

    SEQKIT_RMDUP(ch_fasta)

    // If testing, sort the FASTA file to get consistent output, otherwise skip
    if (params.sort_fasta) {
        // Use seqkit to remove redundant sequences, based on sequence id because they are already the sequence hash
        SEQKIT_SORT(SEQKIT_RMDUP.out.fasta)
        SEQKIT_SORT.out
            .fasta
            .set{single_ch_fasta}
    } else {
        SEQKIT_RMDUP.out
            .fasta
            .set{single_ch_fasta}
    }

    if (params.fasta_splits > 1){
        SEQKIT_SPLIT(
            single_ch_fasta,
            params.fasta_splits
            )
        SEQKIT_SPLIT
            .out
            .fasta
            .flatten()
            .set{ch_split_fasta}
    } else {
        ch_split_fasta = single_ch_fasta
    }

    HMM_PREP(ch_split_fasta, hmmlist)

    ch_split_fasta.collect().set{all_split_fasta}


    run_blastp = params.htcondor_1 ? false : params.blast
    run_mmseqs2 = params.htcondor_1 ? false : params.mmseqs2
    run_ncbi_taxonomy = params.htcondor_1 ? false : params.ncbi_taxonomy
    run_build_database = params.htcondor_1 ? false : params.build_database


    if (params.htcondor_1){
        HTCONDOR1(HMM_PREP.out.hmms, all_split_fasta)

    }


    // /*
    // ////////////////////////
    // HMM ANNOTATION
    // ////////////////////////
    // */
    // if (params.hmmlist){
    //     HMM_ANNOTATION(ch_split_fasta, hmmlist)
    //     hmmer_result_ch = HMM_ANNOTATION.out.hmmer_result_ch
    // } else {
    //     hmmer_result_ch = file( "dummy_file3.txt", checkIfExists: false )
    // }


println run_blastp
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
        blast_ch = file( "dummy_file1.txt", checkIfExists: false )
    }

    /*
    ////////////////////////
    MMSEQS2
    ////////////////////////
    */
    if (run_mmseqs2){
        MMSEQS2_EASYCLUSTER(single_ch_fasta)
        MMSEQS2_EASYCLUSTER.out.clusterres_cluster
            .set{mmseqs2_ch}
        ch_versions = ch_versions.mix(MMSEQS2_EASYCLUSTER.out.versions)
    } else {
        mmseqs2_ch = file( "dummy_file2.txt", checkIfExists: false )
    }








    /*
    ////////////////////////
    TAXONOMY
    ////////////////////////
    */
    if (run_ncbi_taxonomy){
        NCBI_TAXONOMY_INFO()
        ch_versions = ch_versions.mix(NCBI_TAXONOMY_INFO.out.versions)
    }


    /*
    ////////////////////////
    NEO4J_HEADERS
    ////////////////////////
    */
    NEO4J_HEADERS(sg_modules, hmmlist)
    ch_versions = ch_versions.mix(NEO4J_HEADERS.out.versions)

    /*
    ////////////////////////
    BUILD NEO4J DATABASE
    ////////////////////////
    */
    // collected_version_files ensures everythin was run first
    collected_version_files = ch_versions.collectFile(name: 'temp.yml', newLine: true)

    if (run_build_database) {
        outdir_neo4j_ch = Channel.fromPath(params.outdir_neo4j)

        NEO4J_ADMIN_IMPORT(
            outdir_neo4j_ch,
            sg_modules,
            hmmlist,
            collected_version_files
        )
        ch_versions = ch_versions.mix(NEO4J_ADMIN_IMPORT.out.versions)
    }

    /*
    ////////////////////////
    OUTPUT SOFTWARE VERSIONS
    ////////////////////////
    */
    // CUSTOM_DUMPSOFTWAREVERSIONS (
    //     collected_version_files
    // )

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
