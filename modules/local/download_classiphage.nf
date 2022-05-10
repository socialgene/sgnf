
process DOWNLOAD_CLASSIPHAGE {
    label 'process_low'

    output:
    path "classiphage", emit: classiphage

    script:
    """
    # was getting gzip errors when using curl and zcat
    mkdir classiphage
    cd classiphage

    wget http://appmibio.uni-goettingen.de/software/ClassiPhage/Ino_refined_HMMs.zip
    wget http://appmibio.uni-goettingen.de/software/ClassiPhage/Myo_refined_HMMs.zip
    wget http://appmibio.uni-goettingen.de/software/ClassiPhage/Podo_refined_HMMs.zip
    wget http://appmibio.uni-goettingen.de/software/ClassiPhage/Sipho_refined_HMMs.zip


    unzip -oq Ino_refined_HMMs.zip
    unzip -oq Myo_refined_HMMs.zip
    unzip -oq Podo_refined_HMMs.zip
    unzip -oq Sipho_refined_HMMs.zip

    rm -rf __MACOSX

    # move hmm files to ./classiphage
    find ./ -name "*cons.hmm" -exec mv -t . {} +

    rm Ino_refined_HMMs.zip Myo_refined_HMMs.zip Podo_refined_HMMs.zip Sipho_refined_HMMs.zip
    rm -rf Ino_refined_HMMs Myo_refined_HMMs Podo_refined_HMMs Sipho_refined_HMMs

    cd ..
    # convert hmm models to version 3
    bash hmmconvert_loop.sh

    # remove any non-hmm files
    bash local_rsync_only_hmm.sh "classiphage"
    """
}

