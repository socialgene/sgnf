
// process PYHMMER {
//     label 'process_high'

//     input:
//     tuple path(hmm), path(fasta)

//     output:
//     path "*.parseddomtblout.gz", emit: parseddomtblout, optional:true

//     script:
//     """
//     socialgene_run_pyhmmer \\
//         --hmm_filepath ${hmm} \\
//         --sequence_file_path ${fasta} \\
//         --cpus ${task.cpus} \\
//         --outpath 'parseddomtblout.gz' |\\
//     gzip -3 --rsyncable --stdout > 'parseddomtblout.gz'

//     md5_as_filename.sh 'parseddomtblout.gz' 'parseddomtblout.gz'

//     cat <<-END_VERSIONS > versions.yml
//     "${task.process}":
//         python: \$(python --version 2>&1 | tail -n 1 | sed 's/^Python //')
//         socialgene: \$(socialgene_version)
//     END_VERSIONS
//     """
// }
