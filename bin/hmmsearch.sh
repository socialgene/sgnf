#!/bin/bash


#  $1 is the hmm profile; gzip file name with no extensions
#  $2 is the protein fasta; gzip file name with no extensions
# the presence of a $3 trigger behavior for chtc


# Three arguments are provided to switch to CHTC behavior
if [ -n "$3" ]; then
    # to prevent transferring back unwanted files
    # we'll do all the work in a subdirectory "work"
    mkdir work
    # move the hmm and fasta files into the "work" directory
    mv $1.hmm* work/
    mv $2.faa* work/
    # move into the "work" directory
    cd work
    # decompress the input files #TODO UNNECESSARY
    zstd -d --rm "${2}.hmm.zst" # has to be unzipped
    zstd -d --rm "${2}.faa.zst" # has to be unzipped
else
    # the nextflow pipeline (non-chtc) gives the name with extensions
    # remove those
    gzSuffix=".zst"
    hmmSuffix=".hmm"
    faaSuffix=".hmm"

    hmmName="${1}"
    hmmNameNoGZ=$(echo "$hmmName" | sed -e "s/$gzSuffix$//")
    hmmNameBase=$(echo "$hmmName" | sed -e "s/$gzSuffix$//" | sed -e "s/$hmmSuffix$//")

    pfastaName="${2}"
    pfastaNameNoGZ=$(echo "$pfastaName" | sed -e "s/$gzSuffix$//" )
    pfastaNameBase=$(echo "$pfastaName" | sed -e "s/$gzSuffix$//" | sed -e "s/$faaSuffix$//")

    zstd -d -f "${1}" # has to be unzipped
    zstd -d -f "${2}" # has to be unzipped


fi

# Saving new files as "${1}_${2}" only for troubleshooting purposes
# especially for troubleshooting any chtc issues
outfilename="${hmmNameBase}-sgout-${pfastaNameBase}"

# Run hmmsearch
hmmsearch \
    --domtblout "${outfilename}.domtblout" \
    -Z 57096847 \
    -E 100 \
    --cpu 1 \
    --seed 42 \
    "${hmmNameNoGZ}" \
    "${pfastaNameNoGZ}" > /dev/null 2>&1
    #-A "${outfilename}.align" \
    #--tblout "${outfilename}.tblout" \


md5sum "${outfilename}.domtblout" > "${outfilename}.md5"
#md5sum "${outfilename}.tblout" >> "${outfilename}.md5"
#md5sum "${outfilename}.align" >> "${outfilename}.md5"

# Compress the domtblout and alignment files,
# use zstd and not gzip because faster and smaller for chtc
zstd -9 --rm "${outfilename}.domtblout"
#zstd -9 --rm "${outfilename}.tblout"
#zstd -9 --rm "${outfilename}.align"

# Now we create a tar of the files to transfer back on CHTC
# Unnecessary for non-chtc but keeping so that, for now, the
# python script that processes reusults can stay the same between
# the two execution environments
#tar -cvf "results_${outfilename}.tar" "${outfilename}.domtblout.zst" "${outfilename}.tblout.zst" "${outfilename}.align.zst" "${outfilename}.md5" --remove-files
tar -cvf "results_${outfilename}.tar" "${outfilename}.domtblout.zst" "${outfilename}.md5" --remove-files

rm "${hmmNameNoGZ}"
rm "${pfastaNameNoGZ}"
# If on CHTC, move results to tpop dir so it will be sent back
if [ -n "$3" ]; then
    mv results_${outfilename}.tar ../results_${outfilename}.tar
fi
