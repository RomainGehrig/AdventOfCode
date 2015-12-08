from collections import defaultdict

f = open("input.txt", "r")
chars = f.read()

houses = defaultdict(int)
x,y = (0,0)
houses[(x,y)] = 1

for c in chars:
    if c == '>':
        x += 1
    elif c == '<':
        x -= 1
    elif c == 'v':
        y += 1
    elif c == '^':
        y -= 1
    houses[(x,y)] += 1    

print(len(houses.keys()))
