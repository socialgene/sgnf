#!/usr/bin/env python
# -*- encoding: utf-8 -*-
import json
import argparse
from multiprocessing import Pool
import tarfile
from pathlib import Path

parser = argparse.ArgumentParser(description="Extract from antismash json")
parser.add_argument(
    "--input_dir",
    metavar="filepath",
    help="path containing many tgz of antismash results",
    required=True,
)
parser.add_argument(
    "--outpath",
    metavar="filepath",
    help="path to write jsonl",
    required=True,
)

parser.add_argument(
    "--ncpus",
    metavar="int",
    help="ncpus",
    required=True,
)


def read_json(input_path):
    with tarfile.open(input_path, "r") as tar:
        for member in tar:
            if member.name.endswith("_genomic.json"):
                f = tar.extractfile(member)
                return json.load(f).get("records")


def find_tgz(input_dir):
    return Path(input_dir).glob("*.tgz")


def extract(records):
    assembly = None
    try:
        for i in records[0].get("dbxrefs"):
            if i.startswith("Assembly:"):
                assembly = i.replace("Assembly:", "")
    except:
        pass
    return {
        "assembly": assembly,
        "records": [
            {
                record.get("id"): record.get("areas")
                for record in records
                if record.get("areas")
            }
        ],
    }

def outerfun(one_path):
    return extract(read_json(one_path))

def main():
    args = parser.parse_args()
    with Pool(int(args.ncpus)) as pool:
        with open(args.outpath, "w") as outfile:
            for result in pool.imap(outerfun, find_tgz(args.input_dir)):
                json.dump(result, outfile)
                outfile.write("\n")


if __name__ == "__main__":
    main()
