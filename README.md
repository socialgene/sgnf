# ![socialgene/sgnf](docs/images/nf-core-socialgene_logo_light.png#gh-light-mode-only) ![socialgene/sgnf](docs/images/nf-core-socialgene_logo_dark.png#gh-dark-mode-only)

[![GitHub Actions CI Status](https://github.com/socialgene/sgnf/workflows/nf-core%20CI/badge.svg)](https://github.com/socialgene/sgnf/actions?query=workflow%3A%22nf-core+CI%22)
[![GitHub Actions Linting Status](https://github.com/socialgene/sgnf/workflows/nf-core%20linting/badge.svg)](https://github.com/socialgene/sgnf/actions?query=workflow%3A%22nf-core+linting%22)
[![AWS CI](https://img.shields.io/badge/CI%20tests-full%20size-FF9900?labelColor=000000&logo=Amazon%20AWS)](https://nf-co.re/socialgene/results)
[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A522.04.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

[![Get help on Slack](http://img.shields.io/badge/slack-nf--core%20%23socialgene-4A154B?labelColor=000000&logo=slack)](https://nfcore.slack.com/channels/socialgene)
[![Follow on Twitter](http://img.shields.io/badge/twitter-%40nf__core-1DA1F2?labelColor=000000&logo=twitter)](https://twitter.com/nf_core)
[![Watch on YouTube](http://img.shields.io/badge/youtube-nf--core-FF0000?labelColor=000000&logo=youtube)](https://www.youtube.com/c/nf-core)

```bash

genome_url='https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/900/016/785/GCF_900016785.1_BTsPazieg1.0/GCF_900016785.1_BTsPazieg1.0_genomic.gbff.gz'
curl -s $genome_url > /tmp/GCF_900016785.1_BTsPazieg1.0_genomic.gbff.gz


```












#################################################
tar cf - /media/bigdrive2/chase/ncbi_data/gbk/scratch2 | crabz -p 50 > archive.tar.gz
# Process feature tables
find . -type f -name "*feature_table.txt.gz" | xargs zgrep -P "CDS\twith_protein" | cut -f 3,7,8,9,10,12 | gzip -6 --rsyncable > reduced.gz



# Get the tsv (refseq_id\tdecription) for all refseqanonredeundant proteins
find '/media/bigdrive2/chase/socialgene/2022_07_13/refseq_test/refseq_nr_protein_fasta_dir/download_refseq_nonredundant_complete/complete' -type f -name "complete.nonredundant_protein.*.protein.faa.gz" |\
xargs zgrep -h ">" |\
    /media/bigdrive2/chase/socialgene/2022_07_13/parse_fasta.py |\
    gzip -6 --rsyncable > /media/bigdrive2/chase/socialgene/2022_07_13/id_description.tsv.gz
#################################################
