#!/usr/bin/env python

import sys
import gzip

ids = set()
with gzip.open(sys.argv[1], "w") as h2:
    with gzip.open("input_file") as h:
        for line in h:
            if not (id := line.decode().split()[0]) in ids:
                ids.add(id)
                h2.write(line)
