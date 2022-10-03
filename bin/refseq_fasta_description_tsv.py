#!/usr/bin/env python3

import sys

for line in sys.stdin:
    a = line.split(' ', 1)
    sys.stdout.write(f'{a[0].removeprefix(">").strip()}\t{a[1].removeprefix("MULTISPECIES: ").split("[", 1)[0].strip()}\n')
