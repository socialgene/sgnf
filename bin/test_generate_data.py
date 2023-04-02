#!/bin/env python

import argparse
from pathlib import Path
import hashlib
import json


def hash(x):
    with open(x, "rb") as f:
        file_hash = hashlib.md5()
        while chunk := f.read(8192):
            file_hash.update(chunk)
    return file_hash.hexdigest()


parser = argparse.ArgumentParser(description="")

parser.add_argument(
    "--sg_outdir",
    metavar="filepath",
    help="nextflow workflow results directory",
    required=True,
)

parser.add_argument(
    "--outpath",
    metavar="filepath",
    help="json filepath",
    required=True,
)


def main():
    args = parser.parse_args()
    sg_outdir = args.sg_outdir
    outpath = args.outpath

    base_path = Path(sg_outdir, "socialgene_neo4j")

    expected_files = {}

    for i in ["logs", "plugins", "data"]:
        x = Path(base_path).glob(f"{i}/**/*")
        temp = [str(i.relative_to(sg_outdir)) for i in x]
        expected_files[i] = temp

    neo4j_import = Path(base_path).glob("import/**/*")
    import_files = {
        str(i).removeprefix(sg_outdir): hash(i) for i in neo4j_import if i.is_file()
    }

    z = {"import_files": import_files, "expected_files": expected_files}
    with open(outpath, "w") as outfile:
        json.dump(z, outfile)


if __name__ == "__main__":
    main()
