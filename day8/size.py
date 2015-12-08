f = open("input.txt", "r")
lines = f.readlines()


def process(l):
    s = []
    for c in l:
        if c in "\"\\":
            s.append("\\%s" % c)
        else:
            s.append(c)
    return "".join(s)

total = 0
for l in lines:
    l = l[:-1]
    pl = process(l)
    total += 2 + len(pl) - len(l)

print(total)
