import re

f = open("input.txt", "r")
lines = f.readlines()
f.close()

total_time = 2503

class Reindeer(object):
    def __init__(self, name, speed, time, rest):
        self.name = name
        self.speed = int(speed)
        self.time = int(time)
        self.rest = int(rest)

        self._distance = 0
        self.is_moving = True

        self.t = 0
        self.points = 0

    def next_second(self):
        self.t += 1
        if self.is_moving:
            self._distance += self.speed
            if self.t == self.time:
                self.is_moving = False
                self.t = 0
        else:
            if self.t == self.rest:
                self.is_moving = True
                self.t = 0

    def distance(self):
        return self._distance

reindeers = set()

# Dancer can fly 37 km/s for 1 seconds, but then must rest for 36 seconds.
reg = re.compile("(\S+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.")

for l in lines:
    m = reg.match(l)
    reindeers.add(Reindeer(*m.groups()))

for i in range(total_time):
    for r in reindeers:
        r.next_second()
    best = max(reindeers, key=lambda r: r.distance())
    bests = [ r for r in reindeers if r.distance() == best.distance() ]
    for b in bests:
        b.points += 1

best = max(reindeers, key=lambda r: r.points)
print("%s: %s (%s)" % (best.name, best.distance(), best.points))
