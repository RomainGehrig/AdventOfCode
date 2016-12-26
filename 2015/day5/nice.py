f = open("input.txt", "r")
lines = f.readlines()

def is_nice(s):
    c_ = None
    vowels = 0
    double = False
    for c in s:
        if c in "aeiou":
            vowels += 1
        if c_ is not None:
            if c_ == c:
                double = True
            cc = "%s%s" % (c_,c)
            if cc == "ab" or cc == "cd" or cc == "pq" or cc == "xy":
                return False
        c_ = c

    return vowels >= 3 and double

total = 0
for l in lines:
    if is_nice(l):
        total += 1

print(total)
