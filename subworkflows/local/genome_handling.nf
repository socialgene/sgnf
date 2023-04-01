/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

include { CRABHASH                  } from '../../modules/local/crabhash.nf'
include { MIBIG_DOWNLOAD                    } from '../../modules/local/mibig_download'
include { NCBI_DATASETS_DOWNLOAD            } from '../../modules/local/ncbi_datasets_download'
include { NCBI_GENOME_DOWNLOAD              } from '../../modules/local/ncbi_genome_download'
include { PROCESS_GENBANK_FILES                 } from '../../modules/local/process_genbank_files'
include { DEDUPY as DEDUPLICATE_GENOMIC_INFO    } from '../../modules/local/dedupy'
include { DEDUPY as DEDUPLICATE_PROTEIN_INFO    } from '../../modules/local/dedupy'


workflow GENOME_HANDLING {
    take:
        fasta_ch

    main:
        ch_versions     = Channel.empty()
        gbk_file_ch     = Channel.empty()
        info_ch         = Channel.empty()

        // Create a channel to mix inputs from different sources
        ch_read = Channel.empty()

        if (params.mibig){
            MIBIG_DOWNLOAD()
            gbk_file_ch = gbk_file_ch.mix(MIBIG_DOWNLOAD.out.genbank)
            ch_versions = ch_versions.mix(MIBIG_DOWNLOAD.out.versions)
        }

        if (params.ncbi_genome_download_command){
            NCBI_GENOME_DOWNLOAD(params.ncbi_genome_download_command)
            gbk_file_ch = gbk_file_ch.mix(NCBI_GENOME_DOWNLOAD.out.gbff_files)
            ch_versions = ch_versions.mix(NCBI_GENOME_DOWNLOAD.out.versions)
        }

        if (params.local_genbank) {
            temp_file_ch = Channel.fromPath( params.local_genbank )
            gbk_file_ch= gbk_file_ch.mix(temp_file_ch)
        }

        if (params.ncbi_datasets_command){

            if (!params.ncbi_datasets_file){
                ch_opt_input_file = file("NO_FILE")
            } else {
                opt_input_file = file(params.ncbi_datasets_file)
                ch_opt_input_file = Channel.fromList(opt_input_file.splitText( by: 5000 , compress:false, file:true))
            }

            NCBI_DATASETS_DOWNLOAD(params.ncbi_datasets_command, ch_opt_input_file)
            gbk_file_ch= gbk_file_ch.mix(NCBI_DATASETS_DOWNLOAD.out.gbff_files)
            ch_versions = ch_versions.mix(NCBI_DATASETS_DOWNLOAD.out.versions)
        }

        if (fasta_ch) {
            gbk_and_fasta_ch = gbk_file_ch.mix(fasta_ch)
        }

        PROCESS_GENBANK_FILES(
                gbk_and_fasta_ch.flatten().toSortedList().flatten().buffer( size: params.genbank_input_buffer, remainder: true ),
                )

        PROCESS_GENBANK_FILES.out.fasta.set{ch_fasta_out}

        ch_versions = ch_versions.mix(PROCESS_GENBANK_FILES.out.versions)

        PROCESS_GENBANK_FILES.out.protein_info.set{protein_info}


    PROCESS_GENBANK_FILES.out.protein_ids
        .collectFile(name:'protein_ids.gz', sort: false )
        .map {[it.getSimpleName(), it]}
        .set{ch_protein_ids}

    PROCESS_GENBANK_FILES.out.protein_info
        .collectFile(name:'protein_info.gz', sort: false )
        .map {[it.getSimpleName(), it]}
        .set{ch_protein_info}
    PROCESS_GENBANK_FILES.out.locus_to_protein
        .collectFile(name:'locus_to_protein.gz', sort: false )
        .map {[it.getSimpleName(), it]}
        .set{ch_locus_to_protein}
    PROCESS_GENBANK_FILES.out.assembly_to_locus
        .collectFile(name:'assembly_to_locus.gz', sort: false )
        .map {[it.getSimpleName(), it]}
        .set{ch_assembly_to_locus}
    PROCESS_GENBANK_FILES.out.assembly_to_taxid
        .collectFile(name:'assembly_to_taxid.gz', sort: false )
        .map {[it.getSimpleName(), it]}
        .set{ch_assembly_to_taxid}
    PROCESS_GENBANK_FILES.out.loci
        .collectFile(name:'loci.gz', sort: false )
        .map {[it.getSimpleName(), it]}
        .set{ch_loci}
    PROCESS_GENBANK_FILES.out.assembly
        .collectFile(name:'assembly.gz', sort: false )
        .map {[it.getSimpleName(), it]}
        .set{ch_assembly}


    ch_genomic_to_dedup = ch_locus_to_protein.mix(
        ch_locus_to_protein,
        ch_assembly_to_locus,
        ch_assembly_to_taxid,
        ch_loci,
        ch_assembly)

    ch_protein_to_dedup = ch_protein_ids.mix(ch_protein_info)

    DEDUPLICATE_GENOMIC_INFO(ch_genomic_to_dedup)
    DEDUPLICATE_PROTEIN_INFO(ch_protein_to_dedup)




    emit:
        ch_genome_info  = DEDUPLICATE_GENOMIC_INFO.out.collect()
        ch_protein_info = DEDUPLICATE_PROTEIN_INFO.out.collect()
        ch_gbk          = gbk_file_ch.flatten().toSortedList().flatten()
        ch_fasta        = ch_fasta_out
        ch_versions     = ch_versions


}
