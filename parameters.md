# socialgene/sgnf pipeline parameters

Scalable genome mining with SocialGene knowledge graphs

## Input Genomes

Any one or more of the following can be used to download/input genomes for the pipeline

| Parameter                      | Description                                                                                                                                                                                                                                                           | Type      | Default | Required | Hidden |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- | ------- | -------- | ------ |
| `ncbi_genome_download_command` | Arguments to pass to ncbi_genome_download_command <details><summary>Help</summary><small>See the following link for more info about commands you can use:<br>https://github.com/kblin/ncbi-genome-download</small></details>                                          | `string`  |         |          |        |
| `ncbi_datasets_command`        | Taxonomic name (maybe NCBI taxonomy id as well?) see extended help before using <details><summary>Help</summary><small>Note/Warning: <br>Specifying a taxon directly has the potential to download a large number of genomes that you may not be prepared to handle.  |
| `ncbi_datasets_file`           | Instead of using the 'ncbi_datasets_command', the path to a file of NCBI genome accessions to download can provided (single accessio per line)                                                                                                                        | `string`  |         |          |        |
| `local_genbank`                | Path to local GenBank file(s), can be a glob <details><summary>Help</summary><small>Accepted files:<br>gbff, gbk<br>and gzipped versions of those<br></small></details>                                                                                               | `string`  |         |          |        |
| `local_faa`                  | Path to local protein FASTA file(s), can be a glob                                                                                                                                                                                                                    | `string`  |         |          |        |
| `paired_omics_json_path`       | Paired omics json file, downloaded from: https://pairedomicsdata.bioinformatics.nl/projects                                                                                                                                                                           | `string`  |         |          | True   |
| `mibig`                        | Set to true to download and include all MIBiG BGCs as input                                                                                                                                                                                                           | `boolean` |         |          |        |
| `genbank_input_buffer`         | How many genbank files will be processed in a single task <details><summary>Help</summary><small>Decides how many parallel processes will be used for genbank parsing; number of spawned parse processes = (# of input genomes) / (genbank_input_buffer)</small></det |

## Required Output Directories

Define where the pipeline should find input data and save output data.

| Parameter               | Description                                                          | Type     | Default              | Required | Hidden |
| ----------------------- | -------------------------------------------------------------------- | -------- | -------------------- | -------- | ------ |
| `outdir`                | If set, and others not, all other outdirs within this directory      | `string` | socialgene_results   | True     |        |
| `outdir_download_cache` | Long term caching directory for use between different pipeline runs. | `string` | socialgene_downloads | True     |        |

## Input HMMs

Any one or more of the following can be used to download/input HMMs for the pipeline

| Parameter         | Description                                                                                                                                                                                                                                                                  | Type     | Default | Required | Hidden |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- | -------- | ------ |
| `custom_hmm_file` | File path of a custom HMMER hmm file                                                                                                                                                                                                                                         | `string` |         |          |        |
| `hmmlist`         | ["all"] or some combination of ["antismash","amrfinder","bigslice","classiphage","pfam","prism","resfams","tigrfam","virus_orthologous_groups"]                                                                                                                              | `array`  |         |          |        |
| `domtblout_path`  | Use externally-generated domtblout files. Please read the long description before using <details><summary>Help</summary><small>Use externally-generated domtblout files.<br>The models have to have the same name (identifier) as SocialGene expects, which is a SocialGene- |

## Optional directory settings

These directories have defaults based on the --outdir parameter, change them if you want

| Parameter            | Description                                                                                                                                                                     | Type     | Default                                            | Required | Hidden |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------------------------------------------------- | -------- | ------ |
| `outdir_per_run`     | Directory that holds data generated each run                                                                                                                                    | `string` | socialgene_results/socialgene_per_run              |          | True   |
| `outdir_neo4j`       | Path to the output directory where the results will be saved.                                                                                                                   | `string` | socialgene_results/socialgene_neo4j                |          | True   |
| `outdir_blast_cache` | Cache folder where blast results are written to. Important to delete if starting a new pipeline run with different input data but using same cache directory as a previous run. | `string` | socialgene_results/socialgene_per_run/blastp_cache |          | True   |
| `outdir_genomes`     | Storage directory for downloaded genomes                                                                                                                                        | `string` | socialgene_results/outdir_genomes                  |          | True   |

## SocialGene parameters

| Parameter      | Description                                                                                                                                                                                                                                                                      | Type   | Default | Required | Hidden |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------- | -------- | ------ |
| `fasta_splits` | Split non-redundant protein sequences into n-FASTA files <details><summary>Help</summary><small>Use this to run HMMER in parallel/make things faster. Determines how many FASTA files should be the created from all non-redundant protein sequences</small></details>           | `integ |
| `hmm_splits`   | For most use cases keep this at 1 and increase fasta_splits instead <details><summary>Help</summary><small>Determines how many hmm files should be created to run in parallel. This is mainly for making smaller files for massively parallel distribution on CHTC</small></deta |

## SocialGene modules

These determine the annotations and structure of the resulting database

| Parameter        | Description                                                                                                                       | Type      | Default | Required | Hidden |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------- | --------- | ------- | -------- | ------ |
| `build_database` | Should the Neo4j databse be created?                                                                                              | `boolean` | True    |          |        |
| `mmseqs2`        | Run MMseqs2 on the input proteins? <details><summary>Help</summary><small>https://github.com/soedinglab/MMseqs2</small></details> | `boolean` |         |          |        |
| `blastp`         | Should all vs all BLASTp be run? DO NOT RUN ON LARGE INPUT DATA WITHOUT STRICT FILTERS                                            | `boolean` |         |          |        |
| `ncbi_taxonomy`  | Download and insert the NCBI taxonomy database? Requires input assemblies to have NCBI Assembly accessions                        | `boolean` |         |          |        |
| `antismash`      | Run antismash on all input genomes                                                                                                | `boolean` |         |          |        |
| `chembl`         | Include chembl data into database Not yet implemented                                                                             | `boolean` |         |          | True   |
| `paired_omics`   | Not yet implemented                                                                                                               | `boolean` |         |          | True   |

## Max job resource request options

Set the top limit for requested resources for any single job.

| Parameter          | Description                                                                                                                                                                                                                                                                        | Type      | Default | Required | Hidden |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- | ------- | -------- | ------ |
| `max_cpus`         | Maximum number of CPUs that can be requested for any single job. <details><summary>Help</summary><small>Used to set an upper-limit for the number of CPUs that can be used at once. Should be an integer e.g. `--max_cpus 1`<br><br>https://www.nextflow.io/docs/latest/process.ht |
| `max_memory`       | Maximum amount of memory that can be requested for any single job. <details><summary>Help</summary><small>Used to set an upper-limit for the memory any single process can use. Should be a string in the format integer-unit e.g. `--max_memory '8.GB'`<br><br>https://www.nex    |
| `max_time`         | Maximum amount of time that can be requested for any single job. <details><summary>Help</summary><small>Used to set an upper-limit for the amount of time any single process is allowed to run. Should be a string in the format integer-unit e.g. `--max_time '2.h'`<br><br>https |
| `slurm_queue_size` | Number of slurm jobs that can be running/submitted                                                                                                                                                                                                                                 | `integer` | 15      |          | True   |

## External Data Versions

| Parameter                | Description                                                                              | Type     | Default                                  | Required | Hidden |
| ------------------------ | ---------------------------------------------------------------------------------------- | -------- | ---------------------------------------- | -------- | ------ |
| `amrfinder_version`      | Version of amrfinder to download/use                                                     | `string` | 2021-03-01.1                             |          | True   |
| `bigslice_version`       | Version of bigslice to download/use                                                      | `string` | v1.0.0/bigslice-models.2020-04-27        |          | True   |
| `vog_version`            | Version of vog to download/use                                                           | `string` | vog211                                   |          | True   |
| `tigrfam_version`        | Version of tigrfam to download/use                                                       | `string` | 15.0                                     |          | True   |
| `pfam_version`           | PFAM version. Ffor version numbers see: http://ftp.ebi.ac.uk/pub/databases/Pfam/releases | `string` | 35.0                                     |          | True   |
| `antismash_hmms_git_sha` | Controls which version of antismash the antismash HMMS are pulled from                   | `string` | e2d777c6cd035e6bf20f7eec924a350b00b84c7b |          | True   |
| `chembl_version`         | Set (e.g. 31 for chembl version 31) to incorporate chembl into the database              | `string` | None                                     |          |        |

## HMMER Options

| Parameter                   | Description                                                                                                                                                                                                                                                       | Type      | Default   | Required | Hidden |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- | --------- | -------- | ------ |
| `hmmsearch_model_threshold` | --cut_ga or --cut_nc or --cut_tc <details><summary>Help</summary><small>From HMMER documentation:<br>Options controlling model-specific thresholding:<br><br>--cut_ga : use profile's GA gathering cutoffs to set all thresholding<br><br>--cut_nc : use profile' |
| `HMMSEARCH_Z`               | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `integer` | 100000000 |          | True   |
| `HMMSEARCH_IEVALUE`         | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `number`  | 0.1       |          | True   |
| `HMMSEARCH_E`               | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `number`  | 10        |          | True   |
| `HMMSEARCH_DOME`            | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `number`  | 10        |          | True   |
| `HMMSEARCH_INCE`            | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `number`  | 0.1       |          | True   |
| `HMMSEARCH_INCDOME`         | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `number`  | 0.01      |          | True   |
| `HMMSEARCH_SEED`            | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `integer` | 42        |          | True   |
| `HMMSEARCH_F1`              | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `number`  | 0.02      |          | True   |
| `HMMSEARCH_F2`              | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `number`  | 0.001     |          | True   |
| `HMMSEARCH_F3`              | see pg 74-77: http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf                                                                                                                                                                                              | `number`  | 1e-05     |          | True   |

## HTCONDOR specific parameters

These parameters are specific to UW-Madison's CHTC high throuput computing cluster

| Parameter                 | Description                                                                                                                                                                                                                                                                        | Type      | Default                           | Required | Hidden |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- | --------------------------------- | -------- | ------ |
| `htcondor`                | Use the --htcondor flag to create files for htcondor, then run again with the results from the external run <details><summary>Help</summary><small>When --htcondor is set the pipeline will only run the steps required to generate and split the non-redundant FASTA file and HMM |
| `htcondor_request_memory` | See: https://chtc.cs.wisc.edu/uw-research-computing/helloworld                                                                                                                                                                                                                     | `string`  | 1GB                               |          | True   |
| `htcondor_request_cpus`   | See: https://chtc.cs.wisc.edu/uw-research-computing/helloworld                                                                                                                                                                                                                     | `integer` | 1                                 |          | True   |
| `htcondor_request_disk`   | See: https://chtc.cs.wisc.edu/uw-research-computing/helloworld                                                                                                                                                                                                                     | `string`  | 5GB                               |          | True   |
| `htcondor_max_idle`       | See: https://chtc.cs.wisc.edu/uw-research-computing/helloworld                                                                                                                                                                                                                     | `integer` | 100                               |          | True   |
| `htcondor_squid_username` | See: https://chtc.cs.wisc.edu/uw-research-computing/file-avail-squid                                                                                                                                                                                                               | `string`  | cmclark8                          |          | True   |
| `htcondor_WantGlideIn`    | See: https://chtc.cs.wisc.edu/uw-research-computing/helloworld                                                                                                                                                                                                                     | `boolean` | True                              |          | True   |
| `htcondor_WantFlocking`   | See: https://chtc.cs.wisc.edu/uw-research-computing/helloworld                                                                                                                                                                                                                     | `boolean` | True                              |          | True   |
| `htcondor_prep_directory` | Where data to be sent to CHTC will be written                                                                                                                                                                                                                                      | `string`  | socialgene_results/htcondor_cache |          | True   |

## MULTIQC

| Parameter                     | Description | Type     | Default | Required | Hidden |
| ----------------------------- | ----------- | -------- | ------- | -------- | ------ |
| `multiqc_title`               | x           | `string` |         |          |        |
| `multiqc_logo`                | x           | `string` |         |          |        |
| `multiqc_config`              | x           | `string` |         |          |        |
| `max_multiqc_email_size`      | x           | `string` | 25.MB   |          |        |
| `multiqc_methods_description` | x           | `string` |         |          |        |

## Generic options

Less common options for the pipeline, typically set in a config file.

| Parameter            | Description                                                                                                                                                                                                                                                                           | Type      | Default                        | Required | Hidden |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- | ------------------------------ | -------- | ------ |
| `help`               | Display help text.                                                                                                                                                                                                                                                                    | `boolean` |                                |          | True   |
| `email_on_fail`      | Email address for completion summary, only when pipeline fails. <details><summary>Help</summary><small>An email address to send a summary email to when the pipeline is completed - ONLY sent if the pipeline does not exit successfully.</small></details>                           | `string`  |                                |          |
| `plaintext_email`    | Send plain-text email instead of HTML.                                                                                                                                                                                                                                                | `boolean` |                                |          | True   |
| `monochrome_logs`    | Do not use coloured log outputs.                                                                                                                                                                                                                                                      | `boolean` |                                |          | True   |
| `tracedir`           | Directory to keep pipeline Nextflow logs and reports.                                                                                                                                                                                                                                 | `string`  | ${params.outdir}/pipeline_info |          | True   |
| `validate_params`    | Boolean whether to validate parameters against the schema at runtime                                                                                                                                                                                                                  | `boolean` | True                           |          | True   |
| `show_hidden_params` | Show all params when using `--help` <details><summary>Help</summary><small>By default, parameters set as _hidden_ in the schema are not shown on the command line when a user runs with `--help`. Specifying this option will tell the pipeline to show all parameters.<              |
| `hook_url`           | x                                                                                                                                                                                                                                                                                     | `string`  | None                           |          | True   |
| `version`            | Display version and exit.                                                                                                                                                                                                                                                             | `boolean` |                                |          | True   |
| `email`              | Email address for completion summary. <details><summary>Help</summary><small>Set this parameter to your e-mail address to get a summary e-mail with details of the run sent to you when the workflow exits. If set in your user config file (`~/.nextflow/config`) then you don't nee |
| `fasta`              | not used, required by nf-core linter                                                                                                                                                                                                                                                  | `string`  | not-used-but-needed-in-lint    |          | True   |
| `input`              | not used, required by nf-core linter                                                                                                                                                                                                                                                  | `string`  | not-used-but-needed-in-lint    |          | True   |
| `sort_fasta`         | BLAST (and maybe MMseqs2?) differ based on sequence order, setting this to true will sort the protein fasta file first (note: this will make a copy of the data)                                                                                                                      | `boolean` |                                |          | True   |

## Institutional config options

Parameters used to describe centralised config profiles. These should not be edited.

| Parameter                    | Description                                                                                                                                                                                                                                                              | Type     | Default | Required | Hidden |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ------- | -------- | ------ |
| `custom_config_version`      | Git commit id for Institutional configs.                                                                                                                                                                                                                                 | `string` | master  |          | True   |
| `custom_config_base`         | Base directory for Institutional configs. <details><summary>Help</summary><small>If you're running offline, Nextflow will not be able to fetch the institutional config files from the internet. If you don't need them, then this is not a problem. If you do need them |
| `config_profile_name`        | Institutional config name.                                                                                                                                                                                                                                               | `string` |         |          | True   |
| `config_profile_description` | Institutional config description.                                                                                                                                                                                                                                        | `string` |         |          | True   |
| `config_profile_contact`     | Institutional config contact information.                                                                                                                                                                                                                                | `string` |         |          | True   |
| `config_profile_url`         | Institutional config URL link.                                                                                                                                                                                                                                           | `string` |         |          | True   |
