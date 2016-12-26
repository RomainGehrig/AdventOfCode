presents = 29000000

def dividers(n):
    for i in range(1,n//2+1):
        if n % i == 0:
            yield i
    yield n


current = 0
n = 100
inc = 50000
while True:
    d = sum(list(dividers(n))) * 10
    inc = max(1,min(inc,int((presents - d)/(presents + d)*7000 - 500)))
    if d > current:
        current = d
        print("New max: %s (sum = %s) (inc = %s)" % (n, d, inc))
    if d >= presents:
        print("%s: %s" % (n,d))
        break
    n += inc
