f = open("input.txt", "r")
lines = f.readlines()

total = 0
for l in lines:
    le, wi, he = sorted([ int(x) for x in l.split("x") ])
    total += 2*(le + wi) + le*wi*he

print(total)
