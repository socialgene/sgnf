#!/usr/bin/env python3

import os
from string import Template
import itertools
import tarfile
from pathlib import Path
from socialgene.config import env_vars as sg_env
import tarfile
import glob

sg_env = sg_env | dict(os.environ)


# need a custom delimter to avoid messing with the bash substitution
class CustomTemplate(Template):
    delimiter = "%$%"


################################
# check hmm files
################################

WITH_CUTOFFS = glob.glob("socialgene_nr_hmms_file_with_cutoffs_*")
WITHOUT_CUTOFFS = glob.glob("socialgene_nr_hmms_file_without_cutoffs_*")

################################
# write sample_matrix.csv
################################

hmm_files = WITH_CUTOFFS + WITHOUT_CUTOFFS

# get fasta filenames for tar
with tarfile.open("fasta.tar", "r") as tar:
    fasta_files = [str(Path(i).name) for i in tar.getnames()]

# make lists for 3-column matrix [hmm_file,fasta_file,has_cutoffs]

# WITH_CUTOFFS =true
t1 = [list(i) + ["true"] for i in list(itertools.product(*[WITH_CUTOFFS, fasta_files]))]
# WITHOUT_CUTOFFS =true
t2 = [list(i) + ["false"] for i in list(itertools.product(*[WITHOUT_CUTOFFS, fasta_files]))]

with open("sample_matrix.csv", "a") as out_handle:
    for i in t1 + t2:
        # hmm_file,fasta_file,has_cutoffs
        _ = out_handle.write(f"{i[0]},{i[1]},{i[2]}\n")


################################
# write hmmsearch.sh
################################

input = """#!/bin/bash

SECONDS=0
# have job exit if any command returns with non-zero exit status (aka failure)
set -e

#  HMM_INPUT_FILE is the hmm profile; gzip file name with no extensions
#  FASTA_INPUT_FILE is the protein fasta; gzip file name with no extensions
HMM_INPUT_FILE=$1
FASTA_INPUT_FILE=$2

# replace env-name on the right hand side of this line with the name of your conda environment
ENVNAME=socialgene
# if you need the environment directory to be named something other than the environment name, change this line
ENVDIR=$ENVNAME

# these lines handle setting up the environment; you shouldn't have to modify them
export PATH
mkdir $ENVDIR
tar -xzf $ENVNAME.tar.gz -C $ENVDIR
. $ENVDIR/bin/activate


HMM_BASENAME="${HMM_INPUT_FILE%.hmm.gz}"
FAA_BASENAME="${FASTA_INPUT_FILE%.faa.gz}"

zcat ${FASTA_INPUT_FILE} > input_fasta_file.faa

# Saving new files as "${1}_${2}" only for troubleshooting purposes
# especially for troubleshooting any chtc issues
outfilename="${HMM_BASENAME}-sgout-${FAA_BASENAME}"

if [ "$3" = true ]
then
    hmmsearch \
        --domtblout "${outfilename}.domtblout" \
        %$%{hmmsearch_model_threshold} \
        -Z %$%{HMMSEARCH_Z} \
        --F1 %$%{HMMSEARCH_F1} \
        --F2 %$%{HMMSEARCH_F2} \
        --F3 %$%{HMMSEARCH_F3} \
        --seed %$%{HMMSEARCH_SEED} \
        --cpu 1 \
        ${HMM_INPUT_FILE} \
        input_fasta_file.faa > /dev/null 2>&1
else

    hmmsearch \
        --domtblout "${outfilename}.domtblout" \
        -Z %$%{HMMSEARCH_Z} \
        -E %$%{HMMSEARCH_E} \
        --domE %$%{HMMSEARCH_DOME} \
        --incE %$%{HMMSEARCH_INCE} \
        --incdomE %$%{HMMSEARCH_INCDOME} \
        --F1 %$%{HMMSEARCH_F1} \
        --F2 %$%{HMMSEARCH_F2} \
        --F3 %$%{HMMSEARCH_F3} \
        --seed %$%{HMMSEARCH_SEED} \
        --cpu 1 \
        ${HMM_INPUT_FILE} \
        input_fasta_file.faa > /dev/null 2>&1
fi

# send files we don't want returned to nope
mkdir nope
mv input_fasta_file.faa nope/input_fasta_file.faa
gzip -6 --rsyncable "${outfilename}.domtblout"
md5sum "${outfilename}.domtblout.gz" > "${outfilename}.sg_md5"
echo "$SECONDS"
"""

result = CustomTemplate(input).substitute(sg_env)
with open("hmmsearch.sh", "w") as out_handle:
    out_handle.writelines(result)


################################
# write chtc_submission_file.sub
################################


input = """# template.sub
# submit file for CHTC jobs

universe = vanilla
log = logs/job_$(Cluster).log
error = errors/job_$(Cluster)_$(Process).err
output = outputs/job_$(Cluster)_$(Process).out

executable = hmmsearch.sh
arguments = $(hmm_model_basename) $(fasta_file_basename) $(has_cutoffs)

should_transfer_files = YES
when_to_transfer_output = ON_EXIT
transfer_input_files = socialgene.tar.gz, http://proxy.chtc.wisc.edu/SQUID/%$%{htcondor_squid_username}/$(hmm_model_basename), sg_input_fasta/$(fasta_file_basename)

request_cpus = %$%{htcondor_request_cpus}
request_memory = %$%{htcondor_request_memory}
request_disk = %$%{htcondor_request_disk}
max_idle = %$%{htcondor_max_idle}

+WantGlideIn = %$%{htcondor_WantGlideIn}
+WantFlocking = %$%{htcondor_WantFlocking}

queue hmm_model_basename fasta_file_basename has_cutoffs from sample_matrix.csv
"""

result = CustomTemplate(input).substitute(sg_env)
with open("chtc_submission_file.sub", "w") as out_handle:
    out_handle.writelines(result)


################################
# write submit_server_setup.sh
################################

input = """#!/bin/bash

##################
# unpack files
##################
mkdir -p logs outputs errors
mkdir sg_input_fasta
tar -xvf fasta.tar -C './sg_input_fasta'
mkdir sg_input_hmms
tar -xvf hmm.tar -C './sg_input_hmms'

cp ./sg_input_hmms/* /squid/%$%{htcondor_squid_username}/
# make sure the squid files will be accessible
chmod +r /squid/%$%{htcondor_squid_username}/*


##################
# create conda env
##################

if ! command -v conda &> /dev/null
then
    echo "conda could not be found, downloading and install first"
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sh Miniconda3-latest-Linux-x86_64.sh
fi
eval "$(conda shell.bash hook)"
conda create -n socialgene -y
conda activate socialgene
conda install -c bioconda hmmer -y
conda deactivate
conda install -c conda-forge conda-pack -y
conda pack -n socialgene
chmod 644 socialgene.tar.gz
"""

result = CustomTemplate(input).substitute(sg_env)
with open("submit_server_setup.sh", "w") as out_handle:
    out_handle.writelines(result)


################################
# write submit_server_finish.sh
################################

input = """#!/bin/bash
find . -name '*.domtblout.gz' -print0 | tar --remove-files -cvf chtc_results.tar --null --files-from -
cat *.sg_md5 > chtc_results.md5
tar uvf chtc_results.tar chtc_results.md5
find . -name '*.sg_md5' -type f -delete
rm chtc_results.md5
"""

with open("submit_server_finish.sh", "w") as out_handle:
    out_handle.writelines(input)

################################
# INSTRUCTIONS
################################


input = """Data files:
    fasta.tar.gz
    hmm.tar.gz
    sample_matrix.csv

Scripts:
    chtc_submission_file.sub
    hmmsearch.sh
    submit_server_setup.sh
    submit_server_finish.sh

Transfer the files to the CHTC submit server you were assigned to by replacing `username` and `htcondor_dir` below then running the scp command

Note: make sure it's the correct submit server!


username='cmclark8'
htcondor_dir='/tmp/socialgene_data/ultraquickstart/htcondor_cache'

scp  ${htcondor_dir}/* ${username}@submit2.chtc.wisc.edu:~${username}

You'll be asked to enter your UW password (the same one you use for email and the same one to login to the CHTC submit node)


-----
On the CHTC submit server

rm -rf logs outputs errors
mkdir logs outputs errors

# this doesn't check if files already exist on the submit node or SQUID, do that manually first
sh submit_server_setup.sh

# submit
condor_submit chtc_submission_file.sub

# tar files for download

sh submit_server_finish.sh

"""


with open("instructions.txt", "w") as out_handle:
    out_handle.writelines(input)
