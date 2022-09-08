#!/usr/bin/env python

import argparse
from pathlib import Path
import hashlib


def hash(x):
    with open(x, "rb") as f:
        file_hash = hashlib.md5()
        while chunk := f.read(8192):
            file_hash.update(chunk)
    return file_hash.hexdigest()


parser = argparse.ArgumentParser(description="Parse NcbiAssembliessdsd taxonomy")

parser.add_argument(
    "--sg_outdir",
    metavar="filepath",
    help="outdir",
    required=True,
)


ground_truth = {
    "/socialgene_per_run/blastp_cache/versions.yml": "668bc3a407e53beaaffbc15c9938f040",
    "/socialgene_per_run/blastp_cache/sorted_nr.fa.gz.dmnd": "2b9cfc7a9f33cd973754ecd20fbe79db",
    "/socialgene_per_run/hmm_cache/socialgene_nr_hmms_file_1_of_1.hmm.gz": "bd72453fd934287d7b152c95b9736eca",
    "/socialgene_per_run/hmm_cache/all_hmms.tsv": "5167fef6200ecfcb5fa57db02a223c07",
    "/socialgene_per_run/hmm_cache/versions.yml": "bd1893db49079930bc62bf360e2ea8ee",
    "/socialgene_per_run/pipeline_info/pipeline_dag_2022-09-07_12-16-02.html": "23a9da3ebf9731db149a9d58523f738e",
    "/socialgene_per_run/pipeline_info/execution_report_2022-09-07_12-16-02.html": "3ce8f91bd98c7228b06faf4552baa0d3",
    "/socialgene_per_run/pipeline_info/execution_trace_2022-09-07_12-16-02.txt": "2943ade32c0bd4d405d0aa59f68e84fc",
    "/socialgene_per_run/pipeline_info/execution_timeline_2022-09-07_12-16-02.html": "13e4a64c3cf9e1f0d585fc129df55f4f",
    "/socialgene_per_run/pipeline_info/software_versions.yml": "f23fd84ee4f908ef9f6d8105b6bba5fe",
    "/socialgene_per_run/mmseqs2_cache/942db0d63ec20c9e9794577e3d42b3bb.mmseqs2_results_rep_seq.fasta.gz": "942db0d63ec20c9e9794577e3d42b3bb",
    "/socialgene_per_run/mmseqs2_cache/versions.yml": "cc97f50936ee0275242b87b3c2996e69",
    "/socialgene_per_run/mmseqs2_cache/a0274ba90f296bbc7fd6374d56c4c8d9.mmseqs2_results_cluster.tsv.gz": "a0274ba90f296bbc7fd6374d56c4c8d9",
    "/socialgene_per_run/mmseqs2_cache/822c4ddbc0cabb88561268f10298b04e.mmseqs2_results_all_seqs.fasta.gz": "822c4ddbc0cabb88561268f10298b04e",
    "/socialgene_neo4j/import.report": "d41d8cd98f00b204e9800998ecf8427e",
    "/socialgene_neo4j/plugins/neo4j-graph-data-science-2.0.3.jar": "0484195f973eeacb29e3b1c6ab145dc0",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshiptypestore.db.id": "252de48f4236c2c522324a3175393d44",
    "/socialgene_neo4j/data/databases/neo4j/neostore.nodestore.db.id": "91e29786428dd5b4f184dedb50d255c7",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db": "a2d7c4a72263ae2dea8ba883a118c151",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.index.id": "37cd4f6cc17fce19fd59228ba52a14dc",
    "/socialgene_neo4j/data/databases/neo4j/neostore.labeltokenstore.db.names": "46266300bfb3e2d8f55ef473082adbe6",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.index": "b1591ba0c89294f6c3b9946b7425e260",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshipgroupstore.db": "66602f170912cf196af06d01565cbc4f",
    "/socialgene_neo4j/data/databases/neo4j/neostore.labeltokenstore.db.id": "92672b9ec37b0f7f96e47dd05a8e1461",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshipstore.db.id": "c9b8678db204dfb9bb1b3ea12ca86ef7",
    "/socialgene_neo4j/data/databases/neo4j/neostore.labeltokenstore.db": "30302536f00e1f50bb857d670affbbec",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshiptypescanstore.db": "0db4f56dce6ada39ce74a1e0f8a7c9ee",
    "/socialgene_neo4j/data/databases/neo4j/neostore.schemastore.db.id": "c722168ae97aa4131af8a3735d45e95d",
    "/socialgene_neo4j/data/databases/neo4j/neostore.labeltokenstore.db.names.id": "252de48f4236c2c522324a3175393d44",
    "/socialgene_neo4j/data/databases/neo4j/neostore.nodestore.db": "9e0a46b063d9048486a482096758ba87",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshipstore.db": "9f8cc68ddd9d2a40f3eb4e38b5c9b226",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.arrays": "ac2bd26131f8eef59b9217fe0c3ed400",
    "/socialgene_neo4j/data/databases/neo4j/neostore.counts.db": "0e1ed008a841afe5363a6bd8cc997b06",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.strings": "f3dd355097c7bc10d91b3b23887ce58d",
    "/socialgene_neo4j/data/databases/neo4j/neostore.schemastore.db": "5f4353f575e59a7504875fb597a4e799",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshipgroupstore.degrees.db": "d808839c1bc376fb157ff38f34a01e43",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshiptypestore.db.names.id": "efc2a0c9b2d8d7f40715c08a4a0bd3ad",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.strings.id": "2b5f19633e7c73dae71eda8fb5c701ed",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.arrays.id": "5cd891254cfec2af72053a0fcf17251b",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.index.keys": "ca3e29ee81345a79b7203f40d8e4f48c",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshipgroupstore.db.id": "3ad856bdf5795cd31448147aff5a1fed",
    "/socialgene_neo4j/data/databases/neo4j/neostore.nodestore.db.labels.id": "5cd891254cfec2af72053a0fcf17251b",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.index.keys.id": "5c80ebcf76fc1ddaceb5e4fd4218db2a",
    "/socialgene_neo4j/data/databases/neo4j/neostore.labelscanstore.db": "e01ff2a88ad1e5efdd1569eb66a37e8e",
    "/socialgene_neo4j/data/databases/neo4j/neostore.nodestore.db.labels": "6e25904141750355bd7859a4f3ea30e6",
    "/socialgene_neo4j/data/databases/neo4j/neostore.propertystore.db.id": "9bc31a8bb7bbf3edfffadae89f195bb3",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshiptypestore.db.names": "c8e7ec4eccbc57e74c9f9e91196235bc",
    "/socialgene_neo4j/data/databases/neo4j/neostore": "770294c38091ebdead5fb115e0efb59d",
    "/socialgene_neo4j/data/databases/neo4j/neostore.relationshiptypestore.db": "7023d82e675da4301f28af9db48ecee7",
    "/socialgene_neo4j/data/transactions/neo4j/neostore.transaction.db.0": "c1087ed7100a1dc1a2796dbd3246440b",
    "/socialgene_neo4j/data/transactions/neo4j/checkpoint.0": "c529e12137771dbd006d6ede11e91c38",
    "/socialgene_neo4j/import/taxdump_process/versions.yml": "c76731df60ac96a6b2cffd90c8c5d03d",
    "/socialgene_neo4j/import/taxdump_process/3990720bc62727149894967690cb03a3.nodes_taxid.gz": "3990720bc62727149894967690cb03a3",
    "/socialgene_neo4j/import/taxdump_process/23e296f220b40ff417adb1e7ddb739be.taxid_to_taxid.gz": "23e296f220b40ff417adb1e7ddb739be",
    "/socialgene_neo4j/import/protein_info/32ac635db104999b2a7cb37040aa842f.protein_info.gz": "32ac635db104999b2a7cb37040aa842f",
    "/socialgene_neo4j/import/diamond_blastp/79956f30b34933af2b205f855fbc064e.blast6.gz": "79956f30b34933af2b205f855fbc064e",
    "/socialgene_neo4j/import/diamond_blastp/versions.yml": "20de3372615bf0495484858c468b2306",
    "/socialgene_neo4j/import/parsed_domtblout/f6b526bb960cbfcb25eeed45bbf16346.parseddomtblout.gz": "f6b526bb960cbfcb25eeed45bbf16346",
    "/socialgene_neo4j/import/parsed_domtblout/4876e9288048b9c813e8f0416ca65d8f.parseddomtblout.gz": "4876e9288048b9c813e8f0416ca65d8f",
    "/socialgene_neo4j/import/parsed_domtblout/a2d4872ffa0059976dadf6f2e38f96a8.parseddomtblout.gz": "a2d4872ffa0059976dadf6f2e38f96a8",
    "/socialgene_neo4j/import/parsed_domtblout/db4700304a42c9cd70c8d6bf8a615270.parseddomtblout.gz": "db4700304a42c9cd70c8d6bf8a615270",
    "/socialgene_neo4j/import/parsed_domtblout/ec320d5bfb458d2ad7269ba3aff0be20.parseddomtblout.gz": "ec320d5bfb458d2ad7269ba3aff0be20",
    "/socialgene_neo4j/import/parsed_domtblout/6afebac1ff9127c07149574b52bc1215.parseddomtblout.gz": "6afebac1ff9127c07149574b52bc1215",
    "/socialgene_neo4j/import/parsed_domtblout/99a557515748092f70ea22bd339b11e5.parseddomtblout.gz": "99a557515748092f70ea22bd339b11e5",
    "/socialgene_neo4j/import/parsed_domtblout/8581e9dbd8bb54e4fb7554d09bfe93bf.parseddomtblout.gz": "8581e9dbd8bb54e4fb7554d09bfe93bf",
    "/socialgene_neo4j/import/parsed_domtblout/5c67e010dd27c8a7f8724b13e43e5586.parseddomtblout.gz": "5c67e010dd27c8a7f8724b13e43e5586",
    "/socialgene_neo4j/import/parsed_domtblout/versions.yml": "77ff696ea126a3cc9385429029827093",
    "/socialgene_neo4j/import/parsed_domtblout/6086371eb3d748f62beef03ef2773bcc.parseddomtblout.gz": "6086371eb3d748f62beef03ef2773bcc",
    "/socialgene_neo4j/import/parsed_domtblout/5b4389b9a360bcde967eb38d054a840a.parseddomtblout.gz": "5b4389b9a360bcde967eb38d054a840a",
    "/socialgene_neo4j/import/parsed_domtblout/02ab64e30de18732041742881baf937e.parseddomtblout.gz": "02ab64e30de18732041742881baf937e",
    "/socialgene_neo4j/import/parsed_domtblout/95f2f901b2962ad0006b1da9028f7eb7.parseddomtblout.gz": "95f2f901b2962ad0006b1da9028f7eb7",
    "/socialgene_neo4j/import/parsed_domtblout/2df84684f8773bca341cadbc8c03e35a.parseddomtblout.gz": "2df84684f8773bca341cadbc8c03e35a",
    "/socialgene_neo4j/import/parsed_domtblout/955eaf47ba51538175cad9a8223b2912.parseddomtblout.gz": "955eaf47ba51538175cad9a8223b2912",
    "/socialgene_neo4j/import/parsed_domtblout/4252aabf8bc8f64c114a372986937f08.parseddomtblout.gz": "4252aabf8bc8f64c114a372986937f08",
    "/socialgene_neo4j/import/parameters/2bdd13c1d6c66b452c1c380c89dac92a.socialgene_parameters.gz": "2bdd13c1d6c66b452c1c380c89dac92a",
    "/socialgene_neo4j/import/mmseqs2_easycluster/942db0d63ec20c9e9794577e3d42b3bb.mmseqs2_results_rep_seq.fasta.gz": "942db0d63ec20c9e9794577e3d42b3bb",
    "/socialgene_neo4j/import/mmseqs2_easycluster/versions.yml": "cc97f50936ee0275242b87b3c2996e69",
    "/socialgene_neo4j/import/mmseqs2_easycluster/a0274ba90f296bbc7fd6374d56c4c8d9.mmseqs2_results_cluster.tsv.gz": "a0274ba90f296bbc7fd6374d56c4c8d9",
    "/socialgene_neo4j/import/mmseqs2_easycluster/822c4ddbc0cabb88561268f10298b04e.mmseqs2_results_all_seqs.fasta.gz": "822c4ddbc0cabb88561268f10298b04e",
    "/socialgene_neo4j/import/genomic_info/da341ebeda21d155329917f66eaa1277.assembly_to_taxid.gz": "da341ebeda21d155329917f66eaa1277",
    "/socialgene_neo4j/import/genomic_info/c5ad0488e87c3c1572865212815d9b39.locus_to_protein.gz": "c5ad0488e87c3c1572865212815d9b39",
    "/socialgene_neo4j/import/genomic_info/ab274d6163e9f040e9cc1087cd4aa88f.loci.gz": "ab274d6163e9f040e9cc1087cd4aa88f",
    "/socialgene_neo4j/import/genomic_info/b413516d8e4af22f8bce8103183c0806.assembly_to_locus.gz": "b413516d8e4af22f8bce8103183c0806",
    "/socialgene_neo4j/import/genomic_info/04e4e70ca818e2464fcce3c993102371.assemblies.gz": "04e4e70ca818e2464fcce3c993102371",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.local_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.bigslice_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.virus_orthologous_groups_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.amrfinder_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.prism_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/versions.yml": "3024138158a35aeb328df3de5ba794d6",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.pfam_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.resfams_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.tigrfam_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/95b4ad323008bb2728cb0bfc50f005d3.antismash_hmms_out.gz": "95b4ad323008bb2728cb0bfc50f005d3",
    "/socialgene_neo4j/import/hmm_tsv_parse/7029066c27ac6f5ef18d660d5741979a.classiphage_hmms_out.gz": "7029066c27ac6f5ef18d660d5741979a",
    "/socialgene_neo4j/import/hmm_tsv_parse/87811de58177e6872d5cf6c45ebe346b.sg_hmm_nodes_out.gz": "87811de58177e6872d5cf6c45ebe346b",
    "/socialgene_neo4j/import/neo4j_headers/protein_info.header": "bf0197bca389043bd7f5be0bbddab134",
    "/socialgene_neo4j/import/neo4j_headers/protein_to_hmm_header.header": "6a600653c416e901a9f5f57850a7df57",
    "/socialgene_neo4j/import/neo4j_headers/antismash_hmms_out.header": "d7277102a630fdc5ccec56d2f4f6ec65",
    "/socialgene_neo4j/import/neo4j_headers/sg_hmm_nodes_out.header": "484071a40dcc110a1e7698ea4dbb12b6",
    "/socialgene_neo4j/import/neo4j_headers/mmseqs2.header": "5b191c60314719d8f501c35eee7950c6",
    "/socialgene_neo4j/import/neo4j_headers/blastp.header": "73dcdcb237ea88ed5ccff662110e9b96",
    "/socialgene_neo4j/import/neo4j_headers/parameters.header": "bfccc8ca760cdd40b8c6faed661e0d1a",
    "/socialgene_neo4j/import/neo4j_headers/locus.header": "6a58a48ab2c8d8f641280aac68d09dfd",
    "/socialgene_neo4j/import/neo4j_headers/taxid.header": "c7e0c717b4cf917544017da85f37c7eb",
    "/socialgene_neo4j/import/neo4j_headers/assembly_to_taxid.header": "3f9af852094b60745dc22f1a36c876c8",
    "/socialgene_neo4j/import/neo4j_headers/versions.yml": "2de0475529d91f7dd659eddbac6d3e00",
    "/socialgene_neo4j/import/neo4j_headers/assembly_to_locus.header": "14f9e0e8ffbd25b240dce27e49d9c0ae",
    "/socialgene_neo4j/import/neo4j_headers/locus_to_protein.header": "44e1aae080b0b65a9081d77511efe2c0",
    "/socialgene_neo4j/import/neo4j_headers/assembly.header": "c9da874fb88e75c70dcd18b3ada3a813",
    "/socialgene_neo4j/import/neo4j_headers/antismash_hmms_out_relationships.header": "5d3e5fd06930d3c0966bacfebd9140e2",
    "/socialgene_neo4j/import/neo4j_headers/taxid_to_taxid.header": "cc049bd566ccc90ca64a6cf5ccbd7f5c",
}


def run_tests(sg_outdir):
    print("Running tests")
    p = Path(sg_outdir).glob("**/*")
    files = {str(x).removeprefix(sg_outdir): hash(x) for x in p if x.is_file()}
    # Check for missing and extra files:
    missing_files = [x for x in ground_truth.keys() if x not in set(files.keys())]
    extra_files = [x for x in files.keys() if x not in set(ground_truth.keys())]
    for ok in [
        "execution_timeline",
        "execution_trace",
        "execution_report",
        "pipeline_dag",
    ]:
        missing_files = [i for i in missing_files if not Path(i).stem.startswith(ok)]
        extra_files = [i for i in extra_files if not Path(i).stem.startswith(ok)]
    if missing_files != []:
        raise ValueError(f"Missing files: {missing_files}")
        raise
    if extra_files != []:
        raise ValueError(f"Extra files: {extra_files}")
    # check the hashes for files that aren't expected to change
    for ignore in [
        "execution_timeline",
        "execution_trace",
        "execution_report",
        "pipeline_dag",
    ]:
        for i in [i for i in ground_truth.keys() if Path(i).stem.startswith(ignore)]:
            _ = ground_truth.pop(i)
    # ignore neo4j output (can't check via md5)
    for i in [
        i
        for i in ground_truth.keys()
        if str(Path(i).parent) == "/socialgene_neo4j/data/databases/neo4j"
    ]:
        _ = ground_truth.pop(i)
    # ignore neo4j output (can't check via md5)
    for i in [
        i
        for i in ground_truth.keys()
        if str(Path(i).parent) == "/socialgene_neo4j/data/transactions/neo4j"
    ]:
        _ = ground_truth.pop(i)
    # check file hashes
    good = []
    bad = []
    for k, v in ground_truth.items():
        if files[k] == v:
            good.append(k)
        else:
            bad.append(k)
    if bad != []:
        raise ValueError(f"File hash incorrect: {[i for i in bad]}")
    print("Passed")


def main():
    args = parser.parse_args()
    run_tests(args.sg_outdir)


if __name__ == "__main__":
    main()
