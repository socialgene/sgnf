#!/usr/bin/env python3

import os
import glob

cwd = os.getcwd()
the_filepaths = glob.glob(os.path.join(cwd, "ncbi_dataset", "data", "**", "*.gbff.gz"))

for single_file in the_filepaths:
    parent_dir = os.path.dirname(single_file)
    acc = os.path.basename(parent_dir)
    os.rename(single_file, os.path.join(parent_dir, f"{acc}.gbff.gz"))
