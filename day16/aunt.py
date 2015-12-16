import re

f = open("input.txt", "r")
lines = f.readlines()
f.close()

aunts = {}

# Sue 1: cars: 9, akitas: 3, goldfish: 0
sue_num = re.compile("Sue (\d+)")
compounds_reg = re.compile("(\S+): (\d+)")
compounds = { "children": 3,
              "cats": 7,
              "samoyeds": 2,
              "pomeranians": 3,
              "akitas": 0,
              "vizslas": 0,
              "goldfish": 5,
              "trees": 3,
              "cars": 2,
              "perfumes": 1 }

sues = {}

for l in lines:
    n = sue_num.match(l).groups()[0]
    com = compounds_reg.findall(l)
    if com is not None:
        sues[int(n)] = { k: int(v) for (k,v) in com }
    else:
        print("Couldn't work with: %s" % l)


sues_scores = {}

for s,d in sues.items():
    sues_scores[s] = 0
    for c in d.keys():
        if c in compounds:
            if d[c] == compounds[c]:
                sues_scores[s] += 1
            else:
                sues_scores[s] = 0
                break
