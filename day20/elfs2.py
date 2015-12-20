from collections import defaultdict

presents = 29000000
max_houses = 1000000

houses = defaultdict(int)

lutin = 1
while lutin < max_houses:
    for i in range(1,51):
        if lutin*i >= max_houses:
            break
        houses[i*lutin] += lutin
    lutin += 1

presents_ = presents // 11

print(next((h,p) for (h,p) in sorted(houses.items()) if p >= presents_ ))
