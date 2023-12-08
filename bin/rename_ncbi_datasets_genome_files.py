#!/usr/bin/env python3

import gzip
from pathlib import Path


for input_path in Path(".").glob("**/genomic.gbff.gz"):
    assembly = None
    with gzip.open(input_path, "rt") as f:
        for line in f:
            if line.startswith("            Assembly: "):
                assembly = line.strip().split(": ")[1].strip()
                break
    filename = input_path.name
    if assembly:
        # change file name to include assembly
        input_path.replace(input_path.with_name(f"{assembly}.gbff.gz"))
