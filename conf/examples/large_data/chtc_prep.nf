/*
========================================================================================
    Nextflow config file for running minimal tests
========================================================================================
    Defines input files and everything required to run a fast and simple pipeline test.

    Use as follows:

        outdir='/home/chase/Documents/socialgene_data/chtc_test'

        nextflow run . \
            -profile chtc_prep,conda \
            --single_outdir $outdir \
            -resume
----------------------------------------------------------------------------------------
*/

params {
    config_profile_name         = 'chtc_prep'
    config_profile_description  = 'For creating files to annotate on CHTC'
    enable_conda                = true
    max_cpus                    = 24
    max_memory                  = 62.GB
    max_time                    = 6000.h
    hmmlist                     = 'all'
    gbk_input                   = '/home/chase/Documents/data/coed_ecoli/GCF_000005845.2_ASM584v2_genomic.gbff.gz'
    sequence_files_glob         = '*.gz'
    chtc_prep_only              = true
    fasta_splits                = 300
    hmm_splits                  = 5
}

process {

    withName: 'HMM_HASH' {
        publishDir = [
            // Save output files to a folder named after the Nextflow process
            path: { "${params.single_outdir}/hmm_files" },
            mode: 'copy',
        ]
    }

    withName: 'HMM_TSV_PARSE' {
        publishDir = [
            // Save output files to a folder named after the Nextflow process
            path: { "${params.single_outdir}/hmm_info" },
            mode: 'copy',
        ]
    }

    withName: 'PROCESS_GENBANK_FILES' {
        publishDir = [
            // Save output files to a folder named after the Nextflow process
            path: { "${params.single_outdir}/fasta_files" },
            pattern: "*faa.gz",
            mode: 'move',
        ]
    }
}
