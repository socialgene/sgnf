#!/bin/env python

import argparse
import json
from pathlib import Path
import hashlib
from urllib.request import urlopen


parser = argparse.ArgumentParser(description="")

parser.add_argument(
    "--sg_outdir",
    metavar="filepath",
    help="outdir",
    required=True,
)

parser.add_argument(
    "--url",
    metavar="filepath",
    help="url to ground truth  json file ",
    required=False,
    default="https://gist.githubusercontent.com/chasemc/540ba908e617535bdadcd0a3ea9f5ab4/raw/675237d82febb900cc46df706e0c9f263e70ab74/a.json",
)
parser.add_argument("--verbose", action=argparse.BooleanOptionalAction)


def hash(x):
    with open(x, "rb") as f:
        file_hash = hashlib.md5()
        while chunk := f.read(8192):
            file_hash.update(chunk)
    return file_hash.hexdigest()


def check_files_exist(x, sg_outdir, dir_name, expected_files, messenger):
    print(f"Checking Neo4j {dir_name} files...")
    temp = {str(i.relative_to(sg_outdir)) for i in x}
    messenger[dir_name] = {
        "found": [i for i in temp if i in expected_files],
        "not_found": [i for i in expected_files if i not in temp],
        "unexpected": [i for i in temp if i not in expected_files],
    }
    print("Done")


def check_versions_exist(x, messenger):
    print(f"Checking version files")
    expected_files = {
        "socialgene_neo4j/import/tigrfam_info/versions.yml",
        "socialgene_neo4j/import/hmm_tsv_parse/versions.yml",
        "socialgene_neo4j/import/taxdump_process/versions.yml",
        "socialgene_neo4j/import/versions.yml",
        "socialgene_neo4j/import/diamond_blastp/versions.yml",
        "socialgene_neo4j/import/neo4j_headers/versions.yml",
        "socialgene_neo4j/import/mmseqs2_easycluster/versions.yml",
        "socialgene_neo4j/versions.yml",
    }
    messenger["versions"] = {
        "found": [i for i in x if i in expected_files],
        "not_found": [i for i in expected_files if i not in x],
        "unexpected": [i for i in x if i not in expected_files],
    }
    print("Done")


def check_import_files(base_path, sg_outdir, messenger, ground_truth_dict):
    print(f"Checking import files for Neo4j")
    neo4j_import = Path(base_path).glob("import/**/*")
    files = {
        str(i).removeprefix(sg_outdir): hash(i) for i in neo4j_import if i.is_file()
    }
    filenames = set(files.keys())
    expected_filenames = set(ground_truth_dict["import_files"].keys())
    messenger["import"] = {
        "found": [i for i in filenames if i in expected_filenames],
        "not_found": [i for i in expected_filenames if i not in filenames],
        "unexpected": [i for i in filenames if i not in expected_filenames],
        "bad_hash": [
            {
                "file": k,
                "found_hash": v,
                "expected_hash": ground_truth_dict["import_files"][k],
            }
            for k, v in files.items()
            if k in ground_truth_dict["import_files"]
            and v != ground_truth_dict["import_files"][k]
        ],
        "good_hash": [
            k
            for k, v in files.items()
            if k in ground_truth_dict["import_files"]
            and v == ground_truth_dict["import_files"][k]
        ],
    }
    print("Done")


def run_tests(sg_outdir, ground_truth_dict, verbose=False):
    print("Running tests")
    messenger = dict()

    base_path = Path(sg_outdir, "socialgene_neo4j")

    for i in ["logs", "plugins", "data"]:
        check_files_exist(
            x=Path(base_path).glob(f"{i}/**/*"),
            sg_outdir=sg_outdir,
            dir_name=i,
            expected_files=ground_truth_dict["expected_files"][i],
            messenger=messenger,
        )

    check_versions_exist(
        x={
            str(i.relative_to(sg_outdir))
            for i in Path(base_path).glob("**/versions.yml")
        },
        messenger=messenger,
    )

    check_import_files(
        base_path=base_path,
        sg_outdir=sg_outdir,
        messenger=messenger,
        ground_truth_dict=ground_truth_dict,
    )
    errors = False
    print("...........................")
    for k, v in messenger.items():
        print(k)
        if "found" in v:
            print(f"\tExpected files found: {len(v['found'])}")
        if "not_found" in v:
            print(f"\tExpected files not found: {len(v['not_found'])}")
            if v["not_found"]:
                errors = True
                if verbose:
                    for i in v["not_found"]:
                        print(f"\t\t {i}")
        if "unexpected" in v:
            print(f"\tUnexpected files: {len(v['unexpected'])}")
            if v["unexpected"]:
                errors = True
                if verbose:
                    for i in v["unexpected"]:
                        print(f"\t\t {i}")
        if "good_hash" in v:
            print(f"\tFiles with expected hash: {len(v['good_hash'])}")

        if "bad_hash" in v:
            print(f"\tFiles with incorrect hash: {len(v['bad_hash'])}")
            if v["bad_hash"]:
                errors = True
                if verbose:
                    for i in v["bad_hash"]:
                        print(f"\t\t {i}")

    if errors:
        # Here to raise error for CI
        raise Exception("Look at output above to see what failed")


# TODO: CHECK
# command_to_build_neo4j_database.sh
# command_to_build_neo4j_database_with_docker.sh
# /socialgene_per_run/


def main():
    args = parser.parse_args()

    with urlopen(args.url) as h:
        data_json = json.load(h)

    run_tests(
        sg_outdir=args.sg_outdir, ground_truth_dict=data_json, verbose=args.verbose
    )


if __name__ == "__main__":
    main()
