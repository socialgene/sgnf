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
include { HMMSEARCH_PARSE                   } from '../modules/local/hmmsearch_parse.nf'
include { HMM_HASH                          } from '../modules/local/hmm_hash.nf'
include { HMM_TSV_PARSE                     } from '../modules/local/hmm_tsv_parse.nf'
include { MMSEQS2                           } from '../modules/local/mmseqs2.nf'
include { NCBI_DATASETS_DOWNLOAD            } from "../modules/local/ncbi_datasets_download.nf"
include { NEO4J_ADMIN_IMPORT                } from '../modules/local/neo4j_admin_import.nf'
include { NEO4J_HEADERS                     } from '../modules/local/neo4j_headers.nf'
include { PAIRED_OMICS                      } from '../modules/local/paired_omics.nf'
include { PARAMETER_EXPORT_FOR_NEO4J        } from '../modules/local/parameter_export_for_neo4j.nf'
include { PROCESS_GENBANK_FILES             } from '../modules/local/process_genbank_files.nf'
include { PROTEIN_FASTA_DOWNLOAD            } from '../modules/local/protein_fasta_download.nf'
include { PYHMMER                           } from '../modules/local/pyhmmer.nf'
include { REFSEQ_ASSEMBLY_TO_TAXID          } from '../modules/local/refseq_assembly_to_taxid.nf'
include { SEQKIT_SPLIT                      } from '../modules/local/seqkit/split/main.nf'

/*
========================================================================================
    IMPORT LOCAL SUBWORKFLOWS
========================================================================================
*/

include { GATHER_HMMS               } from "../subworkflows/local/gather_hmms.nf"
include { NCBI_TAXONOMY_INFO        } from '../subworkflows/local/ncbi_taxonomy_info.nf'
include { PROCESS_GENOMES           } from '../subworkflows/local/process_genomes.nf'
include { TIGRFAM_INFO              } from '../subworkflows/local/tigrfam_info.nf'

/*
========================================================================================
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
========================================================================================
*/

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
    ch_versions = Channel.empty()

    PARAMETER_EXPORT_FOR_NEO4J()

    PROCESS_GENOMES()

    ch_versions = ch_versions.mix(PROCESS_GENOMES.out.versions)

    if (params.sequence_files_glob) {
        sequence_files_glob = params.sequence_files_glob
    } else {
        sequence_files_glob = "*.gbff.gz"
    }

    if (params.paired_omics_json_path) {
        paired_omics_json_path = file(params.paired_omics_json_path)
        PAIRED_OMICS(paired_omics_json_path)
        sg_modules = sg_modules + " paired_omics"
        ch_versions = ch_versions.mix(PAIRED_OMICS.out.versions)
    }


    // TODO: allow not having taxid
   // REFSEQ_ASSEMBLY_TO_TAXID()

    PROCESS_GENBANK_FILES(
        PROCESS_GENOMES.out.processed_genome_ch,
        params.fasta_splits,
        sequence_files_glob
    )
    ch_versions = ch_versions.mix(PROCESS_GENBANK_FILES.out.versions)

    PROCESS_GENBANK_FILES.out.fasta
        .flatten()
        .set{ch_fasta}

    // if (params.fasta_splits > 1) {
    //     SEQKIT_SPLIT(PROCESS_GENBANK_FILES.out.fasta)
    //     SEQKIT_SPLIT.out.fasta
    //         .flatten()
    //         .set{ch_fasta}
    // } else {
    //     PROCESS_GENBANK_FILES.out.fasta
    //         .set{ch_fasta}
    // }



    if (params.fasta_splits > 1) {
        if(params.blastp || params.mmseqs2) {
            ch_fasta
            .collectFile(name:'concatenated.faa.gz', newLine:false, sort:false)
            .set{single_ch_fasta}
        }
    } else {
        ch_fasta
        .set{single_ch_fasta}
    }

    if (params.blastp){
       sg_modules = sg_modules + " blastp"
        DIAMOND_MAKEDB(single_ch_fasta)
        DIAMOND_BLASTP(single_ch_fasta, DIAMOND_MAKEDB.out.db)
        DIAMOND_BLASTP.out.blastout.collect()
            .set{blast_ch}
        ch_versions = ch_versions.mix(DIAMOND_MAKEDB.out.versions)
        ch_versions = ch_versions.mix(DIAMOND_BLASTP.out.versions)
    } else {
        blast_ch = file( "dummy_file1.txt", checkIfExists: false )
    }

    if (params.mmseqs2){
        MMSEQS2(single_ch_fasta)
        MMSEQS2.out.clusterres_cluster
            .set{mmseqs2_ch}
        sg_modules = sg_modules + " mmseqs2"
        ch_versions = ch_versions.mix(MMSEQS2.out.versions)
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

        GATHER_HMMS()
        ch_versions = ch_versions.mix(GATHER_HMMS.out.versions)

        // if (params.hmmlist.contains("tigrfam")){
        //     // download additional tigrfam info
        //     TIGRFAM_INFO()
        //     ch_versions = ch_versions.mix(TIGRFAM_INFO.out.versions)
        // }
        TIGRFAM_INFO()
        ch_versions = ch_versions.mix(TIGRFAM_INFO.out.versions)
        sg_modules = sg_modules + " tigrfam"

        HMM_HASH(
            GATHER_HMMS.out.hmms,
            params.hmm_splits
        )
       ch_versions = ch_versions.mix(HMM_HASH.out.versions)


        // make a channel that's the cartesian product of hmm model files and fasta files
        HMM_HASH.out.socialgene_hmms
            .flatten()
            .combine(
                ch_fasta
            )
            .set{ hmm_ch }

        //PYHMMER(hmm_ch)
        //hmmer_result_ch = PYHMMER.out.collect()
        HMMER_HMMSEARCH(hmm_ch)
        ch_versions = ch_versions.mix(HMMER_HMMSEARCH.out.versions.first())

        HMMSEARCH_PARSE(HMMER_HMMSEARCH.out.domtblout)
        ch_versions = ch_versions.mix(HMMSEARCH_PARSE.out.versions.first())

        hmmer_result_ch = HMMSEARCH_PARSE.out.parseddomtblout.collect()

        HMM_TSV_PARSE(
            HMM_HASH.out.all_hmms_tsv
        )
        sg_modules = sg_modules + " hmms"
        ch_versions = ch_versions.mix(HMM_TSV_PARSE.out.versions)
    } else {
        hmmer_result_ch = file( "dummy_file3.txt", checkIfExists: false )
    }

    NEO4J_HEADERS(sg_modules)
    ch_versions = ch_versions.mix(NEO4J_HEADERS.out.versions)

    outdir_neo4j_ch = Channel.fromPath( params.outdir_neo4j )

    if (params.build_database) {
        NEO4J_ADMIN_IMPORT(
            outdir_neo4j_ch,
            NEO4J_HEADERS.out.headers,
            hmmer_result_ch,
            blast_ch,
            mmseqs2_ch,
            sg_modules
        )
        ch_versions = ch_versions.mix(NEO4J_ADMIN_IMPORT.out.versions)
    }

    temp = ch_versions.collectFile(name: 'temp.yml', newLine: true)
    CUSTOM_DUMPSOFTWAREVERSIONS (
        temp
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
