import re
from collections import defaultdict

f = open("input.txt", "r")
lines = f.readlines()
f.close()

replacements = defaultdict(list)

molecule = lines[-1][:-1]

change = re.compile("(\S+) => (\S+)")

for l in lines[:-2]:
    m = change.match(l)
    if m is not None:
        (k,v) = m.groups()
        replacements[k].append(v)
    else:
        print("Error reading line: %s" % l)


possible_molecules = set()

for k,ms in replacements.items():
    for m in ms:
        reg = re.compile(k)
        for place in reg.finditer(molecule):
            (fr, to) = place.span()
            possible_molecules.add("%s%s%s" % (molecule[:fr], m, molecule[to:]))



print(len(possible_molecules))
