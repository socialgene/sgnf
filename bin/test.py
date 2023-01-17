#!/bin/env python

import argparse
from pathlib import Path
import hashlib


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
    help="outdir",
    required=True,
)

parser.add_argument("--verbose", action=argparse.BooleanOptionalAction)


import_files = {
    "/socialgene_neo4j/import/antismash_gbk_to_table.tsv.gz": "4c33b3fb0cee1eaf750bef99eff4971a",
    "/socialgene_neo4j/import/versions.yml": "b4f5086f1d21179affe89fbcf71fa72e",
    "/socialgene_neo4j/import/taxdump_process/61a2de9d60cae6902557ba1c4db02a8b.taxid_to_taxid.gz": "61a2de9d60cae6902557ba1c4db02a8b",
    "/socialgene_neo4j/import/taxdump_process/versions.yml": "db3e0c4928bb5d7b21573b950beaf929",
    "/socialgene_neo4j/import/taxdump_process/bd306700c24cec79fd22b1a6f7f8aa86.nodes_taxid.gz": "bd306700c24cec79fd22b1a6f7f8aa86",
    "/socialgene_neo4j/import/protein_info/32ac635db104999b2a7cb37040aa842f.protein_info.gz": "32ac635db104999b2a7cb37040aa842f",
    "/socialgene_neo4j/import/tigrfam_info/9b8528263ab8d2c678521f364c02728e.tigrfam_to_role.gz": "9b8528263ab8d2c678521f364c02728e",
    "/socialgene_neo4j/import/tigrfam_info/e29a730691da87f7dd70a85daa6c2932.tigrfam_to_go.gz": "e29a730691da87f7dd70a85daa6c2932",
    "/socialgene_neo4j/import/tigrfam_info/2deedec3965b082a1536f2a7612820d7.tigrfamrole_to_mainrole.gz": "2deedec3965b082a1536f2a7612820d7",
    "/socialgene_neo4j/import/tigrfam_info/fd9346ea8cff415c25d25158b42a0082.goterm.gz": "fd9346ea8cff415c25d25158b42a0082",
    "/socialgene_neo4j/import/tigrfam_info/2c7d0955644b51186d8fa40e2b71988f.TIGRFAMS_GO_LINK.gz": "2c7d0955644b51186d8fa40e2b71988f",
    "/socialgene_neo4j/import/tigrfam_info/3a5edc8721c146058e104678b250fff2.tigrfam_subrole.gz": "3a5edc8721c146058e104678b250fff2",
    "/socialgene_neo4j/import/tigrfam_info/a0d6530f10e4593fd79ba286a407ac90.tigrfamrole_to_subrole.gz": "a0d6530f10e4593fd79ba286a407ac90",
    "/socialgene_neo4j/import/tigrfam_info/versions.yml": "b858651af9be2475c7cb3a7c587e176a",
    "/socialgene_neo4j/import/tigrfam_info/5ad847d09afb9716bc3c155cba2f89f3.tigrfam_mainrole.gz": "5ad847d09afb9716bc3c155cba2f89f3",
    "/socialgene_neo4j/import/tigrfam_info/93ad0a4066afbbf2ceb20a21a73e7178.tigrfam_role.gz": "93ad0a4066afbbf2ceb20a21a73e7178",
    "/socialgene_neo4j/import/diamond_blastp/versions.yml": "41421128c88b578419b9a5e8a50b91aa",
    "/socialgene_neo4j/import/diamond_blastp/6d5e92488f0de773f4ee57fe1dbd7d24.blast6.gz": "6d5e92488f0de773f4ee57fe1dbd7d24",
    "/socialgene_neo4j/import/parsed_domtblout/cdabbe9b5eb667a46c8da6cedd877f81.parseddomtblout.gz": "cdabbe9b5eb667a46c8da6cedd877f81",
    "/socialgene_neo4j/import/parsed_domtblout/versions.yml": "0769eda2b8bbe7d1c6e3c8a8cefac5a5",
    "/socialgene_neo4j/import/parsed_domtblout/f0cc02562f03ebef750bc011c71300b7.parseddomtblout.gz": "f0cc02562f03ebef750bc011c71300b7",
    "/socialgene_neo4j/import/parameters/374111c1af5d330860b6076094112d0e.socialgene_parameters.gz": "374111c1af5d330860b6076094112d0e",
    "/socialgene_neo4j/import/mmseqs2_easycluster/45eccedb84d932a0eb8b9cf5a097c572.mmseqs2_results_rep_seq.fasta.gz": "45eccedb84d932a0eb8b9cf5a097c572",
    "/socialgene_neo4j/import/mmseqs2_easycluster/versions.yml": "8a47d60909ff06a8d06c22f4d83f2217",
    "/socialgene_neo4j/import/mmseqs2_easycluster/34cb7fd3a02e43ffc09efccfea398634.mmseqs2_results_cluster.tsv.gz": "34cb7fd3a02e43ffc09efccfea398634",
    "/socialgene_neo4j/import/mmseqs2_easycluster/1f001c6a8f7df0abb5069ae04af2b531.mmseqs2_results_all_seqs.fasta.gz": "1f001c6a8f7df0abb5069ae04af2b531",
    "/socialgene_neo4j/import/genomic_info/ea72312fd1f1e5d4aeeac1fb17d300d8.locus_to_protein.gz": "ea72312fd1f1e5d4aeeac1fb17d300d8",
    "/socialgene_neo4j/import/genomic_info/f8d0ecbfdd6f1c40f1fdad282f54607e.assemblies.gz": "f8d0ecbfdd6f1c40f1fdad282f54607e",
    "/socialgene_neo4j/import/genomic_info/0ceea3c94abfab1aae1c0bff5e8609e7.loci.gz": "0ceea3c94abfab1aae1c0bff5e8609e7",
    "/socialgene_neo4j/import/genomic_info/6458341c6a64e5b493e3e00d4a01d09d.assembly_to_taxid.gz": "6458341c6a64e5b493e3e00d4a01d09d",
    "/socialgene_neo4j/import/genomic_info/a7c7a6021675a9a2ed22b4fe0a04d06c.assembly_to_locus.gz": "a7c7a6021675a9a2ed22b4fe0a04d06c",
    "/socialgene_neo4j/import/hmm_tsv_parse/863cfbdd83eb6ccf9529393ce39275fb.resfams_hmms_out.gz": "863cfbdd83eb6ccf9529393ce39275fb",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.bigslice_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.virus_orthologous_groups_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.amrfinder_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.pfam_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/8fa64bbf9a51af7320f644fced5b79cb.local_hmms_out.gz": "8fa64bbf9a51af7320f644fced5b79cb",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.prism_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/versions.yml": "0739f5473209ed2ee53247da8f3cd026",
    "/socialgene_neo4j/import/hmm_tsv_parse/aa121d196419803ba721ce1663a84fac.sg_hmm_nodes_out.gz": "aa121d196419803ba721ce1663a84fac",
    "/socialgene_neo4j/import/hmm_tsv_parse/13b4f64ca5ddf403bc38c9d9966e36e3.antismash_hmms_out.gz": "13b4f64ca5ddf403bc38c9d9966e36e3",
    "/socialgene_neo4j/import/hmm_tsv_parse/51df52ec0890b36ae024541503e9225c.tigrfam_hmms_out.gz": "51df52ec0890b36ae024541503e9225c",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.classiphage_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/neo4j_headers/protein_info.header": "bf0197bca389043bd7f5be0bbddab134",
    "/socialgene_neo4j/import/neo4j_headers/tigrfam_subrole.header": "2365fdb76ebf95329c541db265201c63",
    "/socialgene_neo4j/import/neo4j_headers/tigrfam_mainrole.header": "128bdbf7acdff546dc046da3da3c3745",
    "/socialgene_neo4j/import/neo4j_headers/protein_to_hmm_header.header": "6a600653c416e901a9f5f57850a7df57",
    "/socialgene_neo4j/import/neo4j_headers/antismash_hmms_out.header": "3188e5f649991d30aa7ad935938f9b61",
    "/socialgene_neo4j/import/neo4j_headers/sg_hmm_nodes_out.header": "484071a40dcc110a1e7698ea4dbb12b6",
    "/socialgene_neo4j/import/neo4j_headers/mmseqs2.header": "5b191c60314719d8f501c35eee7950c6",
    "/socialgene_neo4j/import/neo4j_headers/blastp.header": "73dcdcb237ea88ed5ccff662110e9b96",
    "/socialgene_neo4j/import/neo4j_headers/parameters.header": "bfccc8ca760cdd40b8c6faed661e0d1a",
    "/socialgene_neo4j/import/neo4j_headers/locus.header": "822db8fefbe22c65eade31c5d81707dd",
    "/socialgene_neo4j/import/neo4j_headers/taxid.header": "c7e0c717b4cf917544017da85f37c7eb",
    "/socialgene_neo4j/import/neo4j_headers/resfams_hmms_out.header": "33fea41b1d6d13f5c93ddfc0a019633a",
    "/socialgene_neo4j/import/neo4j_headers/tigrfam_hmms_out.header": "cb426f64bc946545e1cb373151df8c2c",
    "/socialgene_neo4j/import/neo4j_headers/assembly_to_taxid.header": "3f9af852094b60745dc22f1a36c876c8",
    "/socialgene_neo4j/import/neo4j_headers/versions.yml": "a8dca11096b72fca0c4d50ac589b515d",
    "/socialgene_neo4j/import/neo4j_headers/tigrfamrole_to_mainrole.header": "d9c3660b2ace6b35ac9f24db5cd92559",
    "/socialgene_neo4j/import/neo4j_headers/assembly_to_locus.header": "14f9e0e8ffbd25b240dce27e49d9c0ae",
    "/socialgene_neo4j/import/neo4j_headers/resfams_hmms_out_relationships.header": "7ecdebdb9876e2b9fd85bb7196865300",
    "/socialgene_neo4j/import/neo4j_headers/locus_to_protein.header": "44e1aae080b0b65a9081d77511efe2c0",
    "/socialgene_neo4j/import/neo4j_headers/assembly.header": "5f1accf82f727080b9995b5646b5369b",
    "/socialgene_neo4j/import/neo4j_headers/tigrfam_to_role.header": "bfeb5ce147a7417be63e2adb943474ed",
    "/socialgene_neo4j/import/neo4j_headers/local_hmms_out_relationships.header": "5d8c17766c352fa3cd9f2ac8e07ea20c",
    "/socialgene_neo4j/import/neo4j_headers/antismash_hmms_out_relationships.header": "5d3e5fd06930d3c0966bacfebd9140e2",
    "/socialgene_neo4j/import/neo4j_headers/pfam_hmms_out.header": "07bdf873431842910c59f84a37046740",
    "/socialgene_neo4j/import/neo4j_headers/tigrfam_to_go.header": "fdd5d3e0a4dd4a5e5b2ec1bc3ebdcb27",
    "/socialgene_neo4j/import/neo4j_headers/goterm.header": "5871ec6e85b2a8947e14f6f1a1b203c7",
    "/socialgene_neo4j/import/neo4j_headers/tigrfam_role.header": "860575661f5dc766d7bd84709acf4327",
    "/socialgene_neo4j/import/neo4j_headers/tigrfamrole_to_subrole.header": "597e590650456e37383dd9d061ad2666",
    "/socialgene_neo4j/import/neo4j_headers/tigrfam_hmms_out_relationships.header": "0f6475cc65b2d3f0fd87fee3f32ab728",
    "/socialgene_neo4j/import/neo4j_headers/taxid_to_taxid.header": "cc049bd566ccc90ca64a6cf5ccbd7f5c",
}
expected_files = {
    "plugins": {"socialgene_neo4j/plugins/emptyfile"},
    "logs": {
        "socialgene_neo4j/logs/debug.log",
        "socialgene_neo4j/logs/http.log",
        "socialgene_neo4j/logs/security.log",
        "socialgene_neo4j/logs/query.log",
    },
    "data": {
        "socialgene_neo4j/data/databases/neo4j/neostore.labeltokenstore.db.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.labeltokenstore.db",
        "socialgene_neo4j/data/databases/neo4j/neostore.labeltokenstore.db.names.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.index.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.nodestore.db.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.relationshipgroupstore.db",
        "socialgene_neo4j/data/transactions/neo4j",
        "socialgene_neo4j/data/databases/neo4j/neostore.relationshiptypestore.db.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.relationshipstore.db.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.id",
        "socialgene_neo4j/data/transactions/neo4j/neostore.transaction.db.0",
        "socialgene_neo4j/data/databases/neo4j/neostore.nodestore.db.labels",
        "socialgene_neo4j/data/databases/neo4j/neostore.relationshiptypestore.db",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.arrays.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.index.keys",
        "socialgene_neo4j/data/databases/neo4j",
        "socialgene_neo4j/data/databases/neo4j/neostore.relationshiptypestore.db.names",
        "socialgene_neo4j/data/databases/neo4j/neostore",
        "socialgene_neo4j/data/databases",
        "socialgene_neo4j/data/databases/neo4j/neostore.nodestore.db",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.arrays",
        "socialgene_neo4j/data/databases/neo4j/neostore.nodestore.db.labels.id",
        "socialgene_neo4j/data/databases/neo4j/schema/index/token-lookup-1.0/1/index-1",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.index",
        "socialgene_neo4j/data/transactions",
        "socialgene_neo4j/data/databases/neo4j/neostore.relationshipgroupstore.degrees.db",
        "socialgene_neo4j/data/databases/neo4j/schema/index/token-lookup-1.0/1",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.strings",
        "socialgene_neo4j/data/databases/neo4j/neostore.relationshiptypestore.db.names.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.strings.id",
        "socialgene_neo4j/data/databases/neo4j/schema/index/token-lookup-1.0/2/index-2",
        "socialgene_neo4j/data/databases/neo4j/schema/index/token-lookup-1.0/2",
        "socialgene_neo4j/data/transactions/neo4j/checkpoint.0",
        "socialgene_neo4j/data/databases/neo4j/neostore.relationshipstore.db",
        "socialgene_neo4j/data/databases/neo4j/neostore.labeltokenstore.db.names",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.index.keys.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.schemastore.db.id",
        "socialgene_neo4j/data/databases/neo4j/schema/index",
        "socialgene_neo4j/data/databases/neo4j/neostore.relationshipgroupstore.db.id",
        "socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db",
        "socialgene_neo4j/data/databases/neo4j/neostore.schemastore.db",
        "socialgene_neo4j/data/databases/neo4j/schema",
        "socialgene_neo4j/data/databases/neo4j/schema/index/token-lookup-1.0",
        "socialgene_neo4j/data/databases/neo4j/neostore.counts.db",
    },
}


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
        "socialgene_neo4j/import/parsed_domtblout/versions.yml",
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


def check_import_files(base_path, sg_outdir, messenger):
    print(f"Checking import files for Neo4j")
    neo4j_import = Path(base_path).glob("import/**/*")
    files = {
        str(i).removeprefix(sg_outdir): hash(i) for i in neo4j_import if i.is_file()
    }
    filenames = set(files.keys())
    expected_filenames = set(import_files.keys())
    messenger["import"] = {
        "found": [i for i in filenames if i in expected_filenames],
        "not_found": [i for i in expected_filenames if i not in filenames],
        "unexpected": [i for i in filenames if i not in expected_filenames],
        "bad_hash": [
            {"file": k, "found_hash": v, "expected_hash": import_files[k]}
            for k, v in files.items()
            if k in import_files and v != import_files[k]
        ],
        "good_hash": [
            k for k, v in files.items() if k in import_files and v == import_files[k]
        ],
    }
    print("Done")


def run_tests(sg_outdir, verbose=False):
    print("Running tests")
    messenger = dict()

    base_path = Path(sg_outdir, "socialgene_neo4j")

    for i in ["logs", "plugins", "data"]:
        check_files_exist(
            x=Path(base_path).glob(f"{i}/**/*"),
            sg_outdir=sg_outdir,
            dir_name=i,
            expected_files=expected_files[i],
            messenger=messenger,
        )

    check_versions_exist(
        x={
            str(i.relative_to(sg_outdir))
            for i in Path(base_path).glob("**/versions.yml")
        },
        messenger=messenger,
    )

    check_import_files(base_path=base_path, sg_outdir=sg_outdir, messenger=messenger)
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
                    print(f'\t\t {v["not_found"]}')
        if "unexpected" in v:
            print(f"\tUnexpected files: {len(v['unexpected'])}")
            if v["unexpected"]:
                errors = True
                if verbose:
                    print(f'\t\t {v["unexpected"]}')
        if "good_hash" in v:
            print(f"\tFiles with expected hash: {len(v['good_hash'])}")

        if "bad_hash" in v:
            print(f"\tFiles with incorrect hash: {len(v['bad_hash'])}")
            if v["bad_hash"]:
                errors = True
                if verbose:
                    print(f'\t\t{v["bad_hash"]}')

    if errors:
        # Here to raise error for CI
        raise Exception("Look at output above to see what failed")


# TODO: CHECK
# command_to_build_neo4j_database.sh
# command_to_build_neo4j_database_with_docker.sh
# /socialgene_per_run/


def main():
    args = parser.parse_args()
    run_tests(sg_outdir=args.sg_outdir, verbose=args.verbose)


if __name__ == "__main__":
    main()
