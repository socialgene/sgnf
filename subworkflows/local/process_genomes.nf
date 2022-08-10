include { NCBI_DATASETS_DOWNLOAD            } from "../../modules/local/ncbi_datasets_download.nf"
include { NCBI_GENOME_DOWNLOAD              } from '../../modules/local/ncbi_genome_download.nf'

workflow PROCESS_GENOMES {

    main:
        ch_versions = Channel.empty()

        if (params.ncbi_genome_download_command){
            NCBI_GENOME_DOWNLOAD(params.ncbi_genome_download_command)
            NCBI_GENOME_DOWNLOAD
                .out
                .gbff_files
                .set{genome_file_ch}
            ch_versions_out = ch_versions.mix(NCBI_GENOME_DOWNLOAD.out.versions)

        } else if (params.local_genbank) {
            genome_file_ch = Channel.fromPath( params.local_genbank ).collect()
            ch_versions_out = ch_versions
        } else if (params.ncbi_datasets_command){
            NCBI_DATASETS_DOWNLOAD(params.ncbi_datasets_command)
            NCBI_DATASETS_DOWNLOAD
                .out
                .gbff_files
                .set{genome_file_ch}

            ch_versions_out = ch_versions.mix(NCBI_DATASETS_DOWNLOAD.out.versions)
        }

    emit:
        processed_genome_ch = genome_file_ch
        versions         = ch_versions_out
}

