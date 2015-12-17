import re

f = open("input.txt", "r")
lines = f.readlines()
f.close()

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

greater_keys = {"trees", "cats"}
lesser_keys = {"pomeranians", "goldfish"}

for s,d in sues.items():
    sues_scores[s] = 0
    for c in d.keys():
        if c in compounds:
            if c in greater_keys and d[c] > compounds[c]:
                sues_scores[s] += 1
            elif c in lesser_keys and d[c] < compounds[c]:
                sues_scores[s] += 1
            elif d[c] == compounds[c] and c not in (lesser_keys | greater_keys):
                sues_scores[s] += 1
            else:
                sues_scores[s] = 0
                break

good_sues = { sue: score for sue,score in sues_scores.items() if score > 0 }
print(str(good_sues))
