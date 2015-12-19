import re
from collections import defaultdict

f = open("input.txt", "r")
lines = f.readlines()
f.close()

replacements = defaultdict(list)
reverse_repl = []# only one possible predecesser

molecule = lines[-1][:-1]

change = re.compile("(\S+) => (\S+)")

for l in lines[:-2]:
    m = change.match(l)
    if m is not None:
        (k,v) = m.groups()
        replacements[k].append(v)
        reverse_repl.append((v,k))
    else:
        print("Error reading line: %s" % l)


reduced = molecule

reverse_repl.sort(key=lambda kv: len(kv[0]),reverse=True)

def possibilities(molecule):
    for r,m in reverse_repl:
        if r in molecule:
            yield molecule.replace(r,m,1)

def reduce_molecule(molecule,count):
    if molecule == 'e':
        return count
    else:
        return next((reduce_molecule(m,count+1) for m in possibilities(molecule)))

print(reduce_molecule(molecule,0))
