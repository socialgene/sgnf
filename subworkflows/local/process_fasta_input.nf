/*
========================================================================================
This is the subworkflow that controls downloading hmm models from all the different
sources. For both the "include" and "workflow" sections, keep in alphabetical order
========================================================================================
*/

params.options = [:]

include { CRABHASH                          } from '../../modules/local/crabhash.nf'
include { SEQKIT_SPLIT                      } from '../../modules/local/seqkit/split/main'

workflow PROCESS_FASTA_INPUT {

    take:
        fasta_paths

    main:
        // override null parameters to some sensible defaults if not set
        if (params.crabhash_cpus){
            crabhash_cpus = params.crabhash_cpus
        } else {
            crabhash_cpus = params.max_cpus
        }
        // if (fasta_paths.size() > crabhash_cpus){
        //     fasta_paths
        //         .collectFile(newLine:true, sort:false, cache:true)
        //         .set{fasta_ch}
        // } else {
        //     fasta_paths
        //         .set{fasta_ch}
        // }


    SEQKIT_SPLIT(fasta_paths, crabhash_cpus)
    SEQKIT_SPLIT.out.fasta
        .collect()
        .set{fasta_collected_ch}
    CRABHASH(fasta_collected_ch, params.crabhash_path, params.crabhash_glob)


    emit:
        fasta           = CRABHASH.out.fasta
        protein_info    = CRABHASH.out.protein_info
}
