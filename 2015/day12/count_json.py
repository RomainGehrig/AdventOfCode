import re

f = open("input.txt", "r")

l = f.read()
f.close()

nums = re.compile("(-?\d+)")

total = 0
for m in nums.findall(l):
    total += int(m)

print(total)
