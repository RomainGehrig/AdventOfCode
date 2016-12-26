from collections import defaultdict

f = open("input.txt", "r")
chars = f.read()

houses = defaultdict(int)
x1,y1 = (0,0)
x2,y2 = (0,0)
houses[(0,0)] = 2

santa = True
for c in chars:
    if santa:
        x,y = x1,y1
    else:
        x,y = x2,y2

    if c == '>':
        x += 1
    elif c == '<':
        x -= 1
    elif c == 'v':
        y += 1
    elif c == '^':
        y -= 1
    houses[(x,y)] += 1    

    if santa:
        x1,y1 = x,y
    else:
        x2,y2 = x,y

    santa ^= True

print(len(houses.keys()))
