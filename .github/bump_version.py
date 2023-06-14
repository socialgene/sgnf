import re
import argparse
parser = argparse.ArgumentParser(
    description=""
)


parser.add_argument(
    "--NEXTFLOW_CONFIG_PATH",
    metavar="filepath",
    required=True,
)
parser.add_argument(
    "--NEW_VERSION",
    metavar="str",
    required=True,
)


# NEXTFLOW_CONFIG_PATH = "/home/chase/Documents/github/kwan_lab/socialgene/sgnf/nextflow.config"
#NEW_VERSION='1.0.0'

def bump_nfconfig(NEXTFLOW_CONFIG_PATH,NEW_VERSION):
    inside_manifest=False
    lines=[]
    with open(NEXTFLOW_CONFIG_PATH, "r") as h:
        for line in h:
            if re.search("manifest {", line):
                inside_manifest=True
            if inside_manifest:
                if re.search("}", line):
                    inside_manifest=False
                if re.search("version", line):
                    line= re.sub(r"'.*'", f"'{NEW_VERSION}'", line )
            lines.append(line)
    with open(NEXTFLOW_CONFIG_PATH, "w") as h:
        h.writelines(lines)

def main():
    args = parser.parse_args()

    bump_nfconfig(args.NEXTFLOW_CONFIG_PATH,args.NEW_VERSION)

if __name__ == "__main__":
    main()
