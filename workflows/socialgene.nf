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

/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/

include { NCBI_TAXONOMY_INFO        } from '../subworkflows/local/ncbi_taxonomy_info'
include { GENOME_HANDLING           } from '../subworkflows/local/genome_handling'
include { HMM_ANNOTATION            } from '../subworkflows/local/hmm_annotation'
include { SG_MODULES                } from '../subworkflows/local/sg_modules'

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

    // paired_omics is not currently implemented
    // if (params.paired_omics_json_path) {
    //     paired_omics_json_path = file(params.paired_omics_json_path)
    //     PAIRED_OMICS(paired_omics_json_path)
    //     sg_modules = sg_modules + " paired_omics"
    //     ch_versions = ch_versions.mix(PAIRED_OMICS.out.versions)
    // }
    // if (params.paired_omics){
    //     sg_modules = sg_modules + " paired_omics"
    // }

    /*
    ////////////////////////
    READ AND PROCESS INPUTS
    ////////////////////////
    */

    GENOME_HANDLING()

    GENOME_HANDLING.out.ch_fasta.set{ch_fasta}
    ch_versions = ch_versions.mix(GENOME_HANDLING.out.ch_versions)

    // If testing, sort the FASTA file to get consistent output, otherwise skip
    if (params.sort_fasta) {
        // Use seqkit to remove redundant sequences, based on sequence id because they are already the sequence hash
        SEQKIT_RMDUP(ch_fasta)
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

    if (params.htcondor_1){


    }
    else if (params.htcondor_2) {


    /*
    ////////////////////////
    HMM ANNOTATION
    ////////////////////////
    */
    if (params.hmmlist){
        HMM_ANNOTATION(single_ch_fasta, hmmlist)
        hmmer_result_ch = HMM_ANNOTATION.out.hmmer_result_ch
    } else {
        hmmer_result_ch = file( "dummy_file3.txt", checkIfExists: false )
    }



    /*
    ////////////////////////
    BLASTP
    ////////////////////////
    */
    if (params.blastp){
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
    if (params.mmseqs2){
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
    if (params.ncbi_taxonomy){
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

    if (params.build_database) {
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
