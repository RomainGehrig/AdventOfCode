import json

f = open("input.txt", "r")
j = json.load(f)
f.close()

def count_struct(struct):
    if type(struct) == int:
        return struct

    is_dict = type(struct) == dict
    is_list = type(struct) == list
    total = 0
    if is_dict:
        for k,v in struct.items():
            if v == "red":
                return 0

            total += count_struct(k)
            total += count_struct(v)
    elif is_list:
        for s in struct:
            total += count_struct(s)

    return total

print(count_struct(j))
