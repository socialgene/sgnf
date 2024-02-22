#!/usr/bin/env python3

from pathlib import Path
import json

# When downloaded from NCBI, the genome files are named genomic.gbff.gz and placed in a folder named after the accession number
# This script renames the files to the accession number using the dataset_catalog.json file

# ├── ncbi_dataset
# │   ├── data
# │   │   ├── assembly_data_report.jsonl
# │   │   ├── dataset_catalog.json
# │   │   ├── GCA_003248315.1
# │   │   │   └── genomic.gbff.gz
# │   │   └── GCF_000506385.1
# │   │       └── genomic.gbff.gz
# │   └── fetch.txt
# └── README.md

# TO

# ├── ncbi_dataset
# │   ├── data
# │   │   ├── assembly_data_report.jsonl
# │   │   ├── dataset_catalog.json
# │   │   ├── GCA_003248315.1
# │   │   │   └── GCA_003248315.1.gbff.gz
# │   │   └── GCF_000506385.1
# │   │       └── GCF_000506385.1.gbff.gz
# │   └── fetch.txt
# └── README.md


current_gbff_paths = list(Path(".").glob(f"**/genomic.gbff.gz"))
lookupdict = {str(Path(i.parents[0].name, i.name)).removesuffix(".gz"): i for i in current_gbff_paths}

for input_path in Path(".").glob("**/dataset_catalog.json"):
    with open(input_path) as f:
        data = json.load(f)
        for i in data["assemblies"]:
            if "accession" in i:
                for ii in i["files"]:
                    if ii["filePath"].endswith("genomic.gbff"):
                        lookupdict[ii["filePath"]].rename(
                            Path(lookupdict[ii["filePath"]]).with_name(f"{i['accession']}.gbff.gz")
                        )


for i in Path(".").glob(f"**/*.gbff.gz"):
    if not i.parents[0].name == i.name.removesuffix(".gbff.gz"):
        print(
            "Assumption is that NCBI dataset files are in a folder named after the accession number\nand files themselves are renamed after teh accession."
        )
        print(f"Expected {i.parents[0].name} but got {i.name.removesuffix('.gbff.gz')}")
        raise ValueError(f"File {i} is not in the correct folder")
