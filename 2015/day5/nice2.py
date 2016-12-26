from collections import defaultdict

f = open("input.txt", "r")
lines = f.readlines()


def is_nice(s):
    c_ = None
    c__ = None
    pairs = defaultdict(int)
    jump = False
    just_double = False
    for c in s:
        if c_ is not None:
            if c != c_:
                pairs[(c,c_)] += 1
                just_double = False
            elif c == c_ and not just_double:
                pairs[(c,c_)] += 1
                just_double = True
            elif just_double:
                just_double = False

            if c__ is not None:
                if c == c__:
                    jump = True
            c__ = c_
        c_ = c
    
    return jump and len([v for v in pairs.values() if v > 1]) >= 1

total = 0
for l in lines:
    if is_nice(l):
        total += 1

print(total)
