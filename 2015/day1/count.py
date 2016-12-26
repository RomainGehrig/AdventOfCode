
f = open("input.txt", "r")
l = f.read()

print(l.count("(") - l.count(")"))
