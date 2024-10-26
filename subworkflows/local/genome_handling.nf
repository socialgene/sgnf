/*
========================================================================================
This is the subworkflow that controls downloading and processing input genomes
========================================================================================
*/

include { MIBIG_DOWNLOAD                        } from '../../modules/local/mibig_download'
include { DOWNLOAD_CHEMBL_DATA                  } from '../../modules/local/download_chembl_data'
include { NCBI_DATASETS_DOWNLOAD                } from '../../modules/local/ncbi_datasets_download'
include { NCBI_GENOME_DOWNLOAD                  } from '../../modules/local/ncbi_genome_download'
include { PROCESS_GENBANK_FILES                 } from '../../modules/local/process_genbank_files'
include { DEDUPE as DEDUPLICATE_GENOMIC_INFO    } from '../../modules/local/dedupe'
include { DEDUPY as DEDUPLICATE_PROTEIN_INFO    } from '../../modules/local/dedupy'
include { PROKKA                                } from '../../modules/nf-core/prokka/main'


workflow GENOME_HANDLING {
    take:
        ch_gbk
        ch_fasta
        ch_fna_files
    main:
        ch_versions             = Channel.empty()
        ch_non_mibig_gbk_file   = ch_gbk

        println("------------------------------")
        println("params.local_genbank: ${ch_gbk}")
        println("------------------------------")


        if (params.mibig){
            MIBIG_DOWNLOAD()
            ch_gbk = ch_gbk.mix(MIBIG_DOWNLOAD.out.genbank)
            ch_versions = ch_versions.mix(MIBIG_DOWNLOAD.out.versions)
        }

        if (params.chembl) {
            DOWNLOAD_CHEMBL_DATA()
            ch_fasta = ch_gbk.mix(DOWNLOAD_CHEMBL_DATA.out.chembl_fa)
            ch_versions = ch_versions.mix(DOWNLOAD_CHEMBL_DATA.out.ch_versions)
        }

        if (params.local_genbank) {
            temp_file_ch = Channel.fromPath( params.local_genbank )
            ch_gbk= ch_gbk.mix(temp_file_ch)
            temp_file_ch2 = Channel.fromPath( params.local_genbank )
            ch_non_mibig_gbk_file = ch_non_mibig_gbk_file.mix(temp_file_ch2)
        }
        
        if (params.ncbi_genome_download_command){
            NCBI_GENOME_DOWNLOAD(params.ncbi_genome_download_command)
            ch_gbk = ch_gbk.mix(NCBI_GENOME_DOWNLOAD.out.gbff_files)
            ch_non_mibig_gbk_file = ch_non_mibig_gbk_file.mix(NCBI_GENOME_DOWNLOAD.out.gbff_files)
            ch_versions = ch_versions.mix(NCBI_GENOME_DOWNLOAD.out.versions)
        }

        if (params.ncbi_datasets_command){

            NCBI_DATASETS_DOWNLOAD()
            ch_gbk= ch_gbk.mix(NCBI_DATASETS_DOWNLOAD.out.gbff_files)
            ch_non_mibig_gbk_file= ch_non_mibig_gbk_file.mix(NCBI_DATASETS_DOWNLOAD.out.gbff_files)
            ch_versions = ch_versions.mix(NCBI_DATASETS_DOWNLOAD.out.versions)
        }

        if (params.local_fna) {
            files = Channel.fromPath( params.local_fna )
            files.toSortedList().flatten().set{files_sorted}
            files_sorted.map {
                def meta = [:]
                meta.id = it.getSimpleName()
                [meta, it]
                }
               .set{ch_contigs}

            PROKKA(ch_contigs, [], [])
            ch_gbk = ch_gbk.mix(PROKKA.out.gbk)
            ch_non_mibig_gbk_file = ch_non_mibig_gbk_file.mix(PROKKA.out.gbk)
            ch_versions = ch_versions.mix(PROKKA.out.versions)
        }

    gbk_and_fasta_ch = ch_gbk.mix(ch_fasta)

    gbk_and_fasta_ch.flatten().toSortedList().flatten()
        .map { file -> tuple(file, file.size()) }
    .set { filesWithSizes }


// Apply the batchFilesBySize function to the files and split into batches
// Collect all files and apply the batchFilesBySize function
// Collect all files and apply the batchFilesBySize function
filesWithSizes 
    .toList() 
    .map { fileList -> batchFilesBySize(fileList, 13 * 1024 * 1024 * 1024) } 
    .flatMap { it } 
    .set { batchedFiles }




    PROCESS_GENBANK_FILES(
        batchedFiles
            // gbk_and_fasta_ch.flatten().toSortedList().flatten().buffer( size: params.genbank_input_buffer, remainder: true ),
            )

    PROCESS_GENBANK_FILES.out.fasta.set{ch_fasta_out}

    ch_versions = ch_versions.mix(PROCESS_GENBANK_FILES.out.versions)

    // sort by hash is needed for caching to work
    PROCESS_GENBANK_FILES.out.protein_ids
        .collect()
        .map {["protein_ids", it]}
        .set{ch_protein_ids}
    PROCESS_GENBANK_FILES.out.protein_to_go
        .collect()
        .map {["protein_to_go", it]}
        .set{ch_protein_to_go}
    PROCESS_GENBANK_FILES.out.locus_to_protein
        .collectFile(name:'locus_to_protein.gz', sort: 'hash', cache: true)
        .map {[it.getSimpleName(), it]}
        .set{ch_locus_to_protein}
    PROCESS_GENBANK_FILES.out.assembly_to_locus
        .collectFile(name:'assembly_to_locus.gz', sort: 'hash', cache: true)
        .map {[it.getSimpleName(), it]}
        .set{ch_assembly_to_locus}
    PROCESS_GENBANK_FILES.out.assembly_to_taxid
        .collectFile(name:'assembly_to_taxid.gz', sort: 'hash', cache: true)
        .map {[it.getSimpleName(), it]}
        .set{ch_assembly_to_taxid}
    PROCESS_GENBANK_FILES.out.loci
        .collectFile(name:'loci.gz', sort: 'hash', cache: true)
        .map {[it.getSimpleName(), it]}
        .set{ch_loci}
    PROCESS_GENBANK_FILES.out.assembly
        .collectFile(name:'assemblies.gz', sort: 'hash', cache: true)
        .map {[it.getSimpleName(), it]}
        .set{ch_assembly}


    ch_genomic_to_dedup = ch_locus_to_protein.mix(
        ch_assembly_to_locus,
        ch_assembly_to_taxid,
        ch_loci,
        ch_assembly)

    ch_protein_to_dedup = ch_protein_ids.mix(ch_protein_to_go)

    DEDUPLICATE_GENOMIC_INFO(ch_genomic_to_dedup)
    DEDUPLICATE_PROTEIN_INFO(ch_protein_to_dedup)

    emit:
        ch_genome_info  = DEDUPLICATE_GENOMIC_INFO.out.deduped.collect()
        ch_protein_info = DEDUPLICATE_PROTEIN_INFO.out.deduped.collect()
        ch_gbk          = ch_gbk.flatten().toSortedList().flatten()
        ch_fasta        = ch_fasta_out
        ch_versions     = ch_versions
        ch_non_mibig_gbk_file = ch_non_mibig_gbk_file.flatten().toSortedList().flatten()


}

// Function to batch files by cumulative size
def batchFilesBySize(filesWithSizes, maxBatchSize) {
    def batches = []
    def currentBatch = []
    def currentBatchSize = 0

    filesWithSizes.each { tuple ->
        def (file, size) = tuple

        // If adding this file exceeds the batch size limit, close the current batch and start a new one
        if (currentBatchSize + size > maxBatchSize && currentBatch) {
            batches << currentBatch
            currentBatch = []
            currentBatchSize = 0
        }
        
        // Add the current file to the batch
        currentBatch << file
        currentBatchSize += size
    }

    // Add the remaining batch if it exists and isn't empty
    if (!currentBatch.isEmpty()) {
        batches << currentBatch
    }

    return batches
}
