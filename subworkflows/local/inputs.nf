include { NCBI_GENOME_DOWNLOAD              } from '../../modules/local/ncbi_genome_download.nf'

workflow LOCAL {
    main:
        gb_files = Channel.fromPath( params.gbk_input ).collect()
    emit:
        gb_files = gb_files

}

workflow NCBI {

    main:
        NCBI_GENOME_DOWNLOAD()
    emit:
        gb_files = NCBI_GENOME_DOWNLOAD.out.gbff_files
}
