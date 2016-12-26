from collections import defaultdict

f = open("input.txt", "r")
lines = f.readlines()
f.close()

game = defaultdict(bool)

for y,l in enumerate(lines):
    for x,c in enumerate(l):
        if c == '#':
            game[(x,y)] = True
        elif c == '.':
            game[(x,y)] = False

def lightup_corners(state):
    for x in [0,99]:
        for y in [0,99]:
            state[(x,y)] = True

def new_state(state):
    new = defaultdict(bool)

    for (x,y), live in state.items():
        new[(x,y)] = False
        neighboors = 0

        # count neighboors
        for dy in [-1,0,1]:
            for dx in [-1,0,1]:
                if dx == 0 and dy == 0:
                    continue
                if (x+dx,y+dy) in state and state[(x+dx,y+dy)]:
                    neighboors += 1

        if live and 2 <= neighboors <= 3:
            new[(x,y)] = True

        if not live and neighboors == 3:
            new[(x,y)] = True

    lightup_corners(new)

    return new

lightup_corners(game)
iterations = 100
for i in range(iterations):
    game = new_state(game)

count = list(game.values()).count(True)
print(count)
