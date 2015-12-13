import re
from itertools import permutations

f = open("input.txt", "r")
lines = f.readlines()
f.close()

happinesses = {}
people = set()

# Carol would gain 55 happiness units by sitting next to David.
reg = re.compile("(\S+) would (gain|lose) (\d+) happiness units by sitting next to (\S+).")

def add_relation(p1, gain_or_lose, happiness_units, p2):
    happiness_units = int(happiness_units)
    if gain_or_lose == 'lose':
        happiness_units = -happiness_units

    people.add(p1)
    people.add(p2)

    happinesses[(p1,p2)] = happiness_units

def calculate_happiness(first_person, pps):
    total = 0
    p_ = first_person
    for p in pps:
        total += happinesses[(p_,p)]
        total += happinesses[(p,p_)]
        p_ = p


    # Join the end of the loop
    total += happinesses[(p_,first_person)]
    total += happinesses[(first_person,p_)]

    return total


for l in lines:
    match = reg.match(l)
    if match is not None:
        add_relation(*match.groups())
    else:
        print("Something went wrong with line: %s" % l)

# As we don't want to generate "cycles" (B -> C -> A is the same here as A -> B -> C),
# we just select a random person that will sit at the same place
first_person = people.pop()

max_happiness = None
for pps in permutations(people):
    hap = calculate_happiness(first_person, pps)

    if max_happiness is None or hap > max_happiness:
        max_happiness = hap
        print("Found new maximum happiness of %s: (%s,%s)" % (hap, first_person, ",".join(pps)))
