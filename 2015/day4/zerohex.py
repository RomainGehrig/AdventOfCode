from hashlib import md5

puzzle_input = b"iwrupvqb"

i = 0
def verify(hexa):
    return hexa.startswith("000000")

while True:
    h = md5(puzzle_input + bytes(str(i), "ascii"))
    if verify(h.hexdigest()):
        print(i)
        break
    i += 1

