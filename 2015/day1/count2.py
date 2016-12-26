
f = open("input.txt", "r")
l = f.read()


level = 0
for i,c in enumerate(l):
    if c == '(':
        level += 1
    if c == ')':
        level -= 1
    if level == -1:
        print(i+1) 
        break
