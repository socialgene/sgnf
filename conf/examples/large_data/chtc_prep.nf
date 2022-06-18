/*
========================================================================================
    Nextflow config file for running minimal tests
========================================================================================
    Defines input files and everything required to run a fast and simple pipeline test.

    Use as follows:

 conda install -c hcc aspera-cli 
 conda install -c bioconda entrez-direct 

/////////////////////// FOR GENBANK:
esearch -db assembly -query 'txid201174[Organism]' \
    | esummary \
    | xtract -pattern DocumentSummary -element FtpPath_GenBank \
    | while read -r line ;
    do
        fname1=$(echo $line | grep -o 'GCA_.*' | sed 's/$/_genomic.gbff.gz/') ;
        fpre=${line#"ftp://ftp.ncbi.nlm.nih.gov/"};
        echo "$fpre/$fname1" >> ftp_list_1;
    done


ascp \
    -i ~/miniconda3/etc/asperaweb_id_dsa.openssh \
    --file-list /home/chase/sg/chtc/ftp_list_1 \
    --mode recv \
    -QTr \
    -l 10g \
    --host 130.14.250.12 \
    --user anonftp  \
    /home/chase/sg/chtc/gbff


/////////////////////// FOR REFSEQ:



esearch -db assembly -query 'txid201174[Organism]' \
    | esummary \
    | xtract -pattern DocumentSummary -element FtpPath_RefSeq \
    | while read -r line ;
    do
        fname1=$(echo $line | grep -o 'GCF_.*' | sed 's/$/_feature_table.txt.gz/') ;
        fname2=$(echo $line | grep -o 'GCF_.*' | sed 's/$/_protein.faa.gz/') ;
        fpre=${line#"ftp://ftp.ncbi.nlm.nih.gov/"};
        echo "$fpre/$fname1" >> ftp_list_1;
        echo "$fpre/$fname2" >> ftp_list_2;
    done

wc -l ftp_list_*

ascp \
    -i ~/miniconda3/etc/asperaweb_id_dsa.openssh \
    --file-list /home/chase/sg/chtc/ftp_list_1 \
    --mode recv \
    -QTr \
    -l 10g \
    --host 130.14.250.12 \
    --user anonftp  \
    /home/chase/sg/chtc/features


ascp \
    -i ~/miniconda3/etc/asperaweb_id_dsa.openssh \
    --file-list /home/chase/sg/chtc/ftp_list_2 \
    --mode recv \
    -QTr \
    -l 10g \
    --host 130.14.250.12 \
    --user anonftp  \
    /home/chase/sg/chtc/fasta

/////////////////////// TO RUN:

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
    max_cpus                    = 80

    max_memory                  = 800.GB
    max_time                    = 6000.h
    hmmlist                     = 'all'
    gbk_input                   = '/home/chase/sg/chtc/fasta'
    crabhash_glob               = 'fasta/*.faa.gz'
    crabhash_path               = '/home/chase/sg/crabhash/target/release'
    chtc_prep_only              = true
    fasta_splits                = 1
    hmm_splits                  = 5
}

process {
    
    withName: 'CRABHASH' {
            cpus = 80
    }
    withName: 'NCBI_DATASETS_DOWNLOAD_TAXON' {
            ext.args   = '--assembly-source genbank'
    }
    
    withName: 'SEQKIT_RMDUP' {
            publishDir = [
            path: { "${params.single_outdir}/fasta" },
            mode: 'move',
        ]
    }
    
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
