#socialgene/sgnf pipeline parameters

Create a SocialGene Database

## SocialGene parameters



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `mode` | Run 'dev' for fast (Not yet implemented) | `string` | null |  | True |
| `fasta_splits` | Split non-redundant protein sequences into x-FASTA files <details><summary>Help</summary><small>Use this to run HMMER in parallel/make things faster. Determines how many FASTA files should be the created from all non-redundant protein sequences</small></details>| `integer` | 1 |  |  |
| `hmm_splits` | For most use cases keep this at 1 and increase fasta_splits instead <details><summary>Help</summary><small>Determines how many hmm files should be created to run in parallel. This is mainly for making smaller files for massively parallel distribution on CHTC</small></details>| `integer` | 1 |  |  |

## SocialGene modules

These determine the annotations and structure of the resulting database

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `mmseqs2` | Run MMseqs2 on the input proteins? <details><summary>Help</summary><small>https://github.com/soedinglab/MMseqs2</small></details>| `boolean` |  |  |  |
| `hmms` | Annotate proteins with HMMer? | `boolean` |  |  |  |
| `hmmlist` | "all" or some combination of ["antismash","amrfinder","bigslice","classiphage","pfam","prism","resfams","tigrfam","virus_orthologous_groups"] | `string` | None |  |  |
| `blastp` | Should all vs all  BLASTp be run? DO NOT RUN ON LARGE DATA | `boolean` |  |  |  |
| `ncbi_taxonomy` | Download and insert the NCBI taxonomy database? Requires input assemblies to have NCBI  Assembly accessions | `boolean` |  |  |  |
| `build_database` | Should the Neo4j databse be created? | `boolean` | True |  |  |
| `paired_omics` | Run paired omics pipeline? | `boolean` |  |  |  |

## Reference genome options

Reference genome related files and options required for the workflow.

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `fasta` | Path to FASTA genome file. <details><summary>Help</summary><small>This parameter is *mandatory* if `--genome` is not specified. If you don't have a BWA index available this will be generated for you automatically. Combine with `--save_reference` to save BWA index for future runs.</small></details>|
`string` |  |  | True |

## Institutional config options

Parameters used to describe centralised config profiles. These should not be edited.

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `custom_config_version` | Git commit id for Institutional configs. | `string` | master |  | True |
| `custom_config_base` | Base directory for Institutional configs. <details><summary>Help</summary><small>If you're running offline, Nextflow will not be able to fetch the institutional config files from the internet. If you don't need them, then this is not a problem. If you do need them, you should download the
files from the repo and tell Nextflow where to find them with this parameter.</small></details>| `string` | https://raw.githubusercontent.com/nf-core/configs/master |  | True |
| `config_profile_name` | Institutional config name. | `string` |  |  | True |
| `config_profile_description` | Institutional config description. | `string` |  |  | True |
| `config_profile_contact` | Institutional config contact information. | `string` |  |  | True |
| `config_profile_url` | Institutional config URL link. | `string` |  |  | True |

## Max job request options

Set the top limit for requested resources for any single job.

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `max_cpus` | Maximum number of CPUs that can be requested for any single job. <details><summary>Help</summary><small>Use to set an upper-limit for the CPU requirement for each process. Should be an integer e.g. `--max_cpus 1`</small></details>| `integer` | 16 |  | True |
| `max_memory` | Maximum amount of memory that can be requested for any single job. <details><summary>Help</summary><small>Use to set an upper-limit for the memory requirement for each process. Should be a string in the format integer-unit e.g. `--max_memory '8.GB'`</small></details>| `string` | 128.GB |  | True |
| `max_time` | Maximum amount of time that can be requested for any single job. <details><summary>Help</summary><small>Use to set an upper-limit for the time requirement for each process. Should be a string in the format integer-unit e.g. `--max_time '2.h'`</small></details>| `string` | 240.h |  | True |

## Generic options

Less common options for the pipeline, typically set in a config file.

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `help` | Display help text. | `boolean` |  |  | True |
| `email_on_fail` | Email address for completion summary, only when pipeline fails. <details><summary>Help</summary><small>An email address to send a summary email to when the pipeline is completed - ONLY sent if the pipeline does not exit successfully.</small></details>| `string` |  |  | True |
| `plaintext_email` | Send plain-text email instead of HTML. | `boolean` |  |  | True |
| `monochrome_logs` | Do not use coloured log outputs. | `boolean` |  |  | True |
| `tracedir` | Directory to keep pipeline Nextflow logs and reports. | `string` | ${params.outdir}/pipeline_info |  | True |
| `validate_params` | Boolean whether to validate parameters against the schema at runtime | `boolean` | True |  | True |
| `show_hidden_params` | Show all params when using `--help` <details><summary>Help</summary><small>By default, parameters set as _hidden_ in the schema are not shown on the command line when a user runs with `--help`. Specifying this option will tell the pipeline to show all parameters.</small></details>|
`boolean` |  |  | True |
| `enable_conda` | Run this workflow with Conda. You can also use '-profile conda' instead of providing this parameter. | `boolean` |  |  | True |
| `outdir` | do not use | `string` | not-used-but-needed-by-code |  | True |
| `email` | Email address for completion summary. <details><summary>Help</summary><small>Set this parameter to your e-mail address to get a summary e-mail with details of the run sent to you when the workflow exits. If set in your user config file (`~/.nextflow/config`) then you don't need to specify this on the
command line for every run.</small></details>| `string` |  |  |  |
| `input` | do not use | `string` | not-used-but-needed-by-code |  | True |

## HMMER Options



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `HMMSEARCH_Z` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `integer` | 100000000 |  | True |
| `HMMSEARCH_IEVALUE` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `number` | 0.1 |  | True |
| `HMMSEARCH_E` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `number` | 10.0 |  | True |
| `HMMSEARCH_DOME` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `number` | 10.0 |  | True |
| `HMMSEARCH_INCE` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `number` | 0.1 |  | True |
| `HMMSEARCH_INCDOME` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `number` | 0.01 |  | True |
| `HMMSEARCH_SEED` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `integer` | 42 |  | True |
| `HMMSEARCH_F1` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `number` | 0.02 |  | True |
| `HMMSEARCH_F2` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `number` | 0.001 |  | True |
| `HMMSEARCH_F3` | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf | `number` | 1e-05 |  | True |

## Output Directories

Define where the pipeline should find input data and save output data.

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `single_outdir` | If set, and others not, all other outdirs within this directory | `string` |  |  |  |
| `outdir_per_run` | Directory that holds data generated each run | `string` |  |  |  |
| `outdir_neo4j` | Path to the output directory where the results will be saved. | `string` | ./results |  |  |
| `genome_downloads` | Storage directory for downloaded genomes | `string` | socialgene_results/genome_downloads |  |  |
| `outdir_blast_cache` | Cache folder where blast results are written to. Important to delete if starting a new pipeline run with different input data but using same cache directory as a previous run. | `string` | socialgene_results/socialgene_per_run/blastp_cache |  |  |
| `outdir_download_cache` | Long term caching directory for downloaded items (e.g. HMM databases, NCBI taxonomy info, etc). For use between different pipeline runs, even with different input data. | `string` | /home/chase/Documents/socialgene_data/download_cache |  |  |

## BIG data mode



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `refseq_nr_protein_fasta_dir` | Directory containing downloaded nr fasta files | `string` | None |  |  |
| `refseq_nr_protein_fasta_glob` | Glob specifying nr fasta files | `string` | **/complete.nonredundant_protein*.protein.faa.gz |  |  |
| `feature_table_dir` | Directory containing downloaded genome feature tables | `string` | None |  |  |
| `feature_table_glob` | Glob specifying genome feature tables | `string` | **/*_feature_table.txt.gz |  |  |
| `crabhash_path` | Path to crabhash executable | `string` | None |  |  |
| `outdir_refseq_cache` | crabhash ouptut (will be large for NCBI nr runs) | `string` | /home/chase/Documents/socialgene_data/refseq_cache |  |  |

## Input data options



| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `ncbi_genome_download_command` | Arguments to pass to ncbi_genome_download_command <details><summary>Help</summary><small>See the following link for more info about commands you can use:
https://github.com/kblin/ncbi-genome-download</small></details>| `string` | --genera \'Micromonospora sp. B006\' bacteria |  |  |
| `ncbi_datasets_command` | Taxonomic name  (maybe NCBI taxonomy id as well?) see extended help before using <details><summary>Help</summary><small>Note/Warning:
Specifying a taxon directly has the potential to download a large number of genomes that you may not be prepared to handle.
I highly recommend searching here (https://www.ncbi.nlm.nih.gov/genome/browse#!/prokaryotes/) first to get an idea of how many input genomes you can expect.


The input argument you provide will replace the `$args` in the command below:

` datasets download genome taxon "$args" --include-gbff --exclude-genomic-cds --exclude-protein --exclude-rna --exclude-seq`

Info on use of NCBI datasets can be found here: https://www.ncbi.nlm.nih.gov/datasets/docs/v1/reference-docs/command-line/datasets/</small></details>| `string` | None |  |  |
| `local_genbank` | Path to local GenBank file(s), can be a glob <details><summary>Help</summary><small>Accepted files:
gbff, gbk
gzipped/TAR versions of those
</small></details>| `string` | None |  |  |
| `paired_omics_json_path` | Paired omics json file, downloaded from: https://pairedomicsdata.bioinformatics.nl/projects | `string` | None |  |  |

It's passed on to Python's glob so any valid Python-glob should work- https://docs.python.org/3/library/glob.html
It should match whatever files are specified by the `local_genbank` parameter
e.g.
```
local_genbank                           = '/home/chase/Downloads/some_folder/*.gbff.gz'
sequence_files_glob         = '*.gbff.gz'
```

```
local_genbank                           = '/home/chase/Downloads/my_single_file.gbff.gz'
sequence_files_glob         = 'my_single_file.gbff.gz'
```</small></details>| `string` | None |  |  |
| `custom_hmm_file` | File path of a custom HMMER hmm file | `string` | None |  |  |

