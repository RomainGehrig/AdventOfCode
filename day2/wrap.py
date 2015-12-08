f = open("input.txt", "r")
lines = f.readlines()

total = 0
for l in lines:
    le, wi, he = [ int(x) for x in l.split("x") ]
    total += 2*(le*wi + wi*he + le*he) + min(le*wi, wi*he, le*he)

print(total)
