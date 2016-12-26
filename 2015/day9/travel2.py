import re
from itertools import permutations

f = open("input.txt", "r")
lines = f.readlines()

dist = re.compile("([A-Za-z]+) to ([A-Za-z]+) = (\d+)")

distances = {}
places = set()

def add_distances(place1, place2, dist):
    k = sorted([place1, place2])
    places.add(place1)
    places.add(place2)
    distances[tuple(k)] = int(dist)

def get_distance(place1,place2):
    return distances[tuple(sorted([place1, place2]))]

def compute_distance(ps):
    last = None
    total = 0
    for p in ps:
        if last is not None:
            total += get_distance(p, last)
        last = p

    return total

for l in lines:
    m = dist.match(l)
    if m is not None:
        add_distances(*m.groups())
    else:
        print("Couldn't match line: %s" % l)

max_dist = 0
for p in permutations(list(places)):
    dist = compute_distance(p)
    if dist > max_dist:
        print("Found new max (%s): %s" % (dist, str(p)))
        max_dist = dist

print(max_dist)
