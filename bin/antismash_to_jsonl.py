#!/usr/bin/python3
# -*- encoding: utf-8 -*-
import argparse
import gzip
import json
import tarfile
from multiprocessing import Pool
from pathlib import Path

parser = argparse.ArgumentParser(description="Extract from antismash json")
parser.add_argument(
    "--jsonpath",
    metavar="filepath",
    help="path of json.gz",
    required=True,
)
parser.add_argument(
    "--outpath",
    metavar="filepath",
    help="path to write jsonl",
    required=True,
)


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
        "records": [{record.get("id"): record.get("areas") for record in records if record.get("areas")}],
    }


def main():
    args = parser.parse_args()
    with open(args.outpath, "w") as outfile:
        with gzip.open(args.jsonpath) as handle:
            json.dump(extract(json.load(handle).get("records")), outfile)
            outfile.write("\n")


if __name__ == "__main__":
    main()
