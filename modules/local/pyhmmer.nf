
// process PYHMMER {
//     label 'process_high'

//     input:
//     tuple path(hmm), path(fasta)

//     output:
//     path "*.parseddomtblout.gz", emit: parseddomtblout, optional:true

//
    when:
    task.ext.when == null || task.ext.when

    script:
//     """
//     sg_run_pyhmmer \\
//         --hmm_filepath ${hmm} \\
//         --sequence_file_path ${fasta} \\
//         --cpus ${task.cpus} \\
//         --outpath 'parseddomtblout.gz' |\\
//     gzip -n -3 --rsyncable --stdout > 'parseddomtblout.gz'

//     md5_as_filename.sh 'parseddomtblout.gz' 'parseddomtblout.gz'

//     cat <<-END_VERSIONS > versions.yml
//     "${task.process}":
//         python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
//         socialgene: \$(sg_version)
//     END_VERSIONS
//     """
// }
