from collections import defaultdict

f = open("input.txt", "r")
lines = f.readlines()

lights = defaultdict(bool)

def apply_to_lights(pos1,pos2,action):
    x1,y1 = pos1
    x2,y2 = pos2

    for x in range(x1,x2+1):
        for y in range(y1,y2+1):
            lights[(x,y)] = action(lights[(x,y)]) 

def toggle(b):
    return b ^ True
def turn_on(b):
    return True
def turn_off(b):
    return False

def parse_pos(s):
    return tuple([ int(p) for p in s.split(",") ])

def get_positions(s):
    pos1,pos2 = s.replace("toggle", "").replace("turn on", "").replace("turn off", "").replace("through", " ").split()
    return parse_pos(pos1),parse_pos(pos2)

for l in lines:
    action = None
    if l.startswith("toggle"):
        action = toggle
    elif l.startswith("turn on"):
        action = turn_on
    elif l.startswith("turn off"):
        action = turn_off
    pos1, pos2 = get_positions(l)

    apply_to_lights(pos1,pos2,action)

print(list(lights.values()).count(True))

