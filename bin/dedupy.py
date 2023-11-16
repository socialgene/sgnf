#!/usr/bin/env python

import sys
import gzip
from pathlib import Path

input_files = Path(".").glob("input_file*")

ids = set()

with gzip.open(f"{sys.argv[1]}.gz", "w") as h2:
    for f in input_files:
        with gzip.open(f, "r") as h:
            for line in h:
                if not (id := line.decode().split()[0]) in ids:
                    ids.add(id)
                    h2.write(line)
