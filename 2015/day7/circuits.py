import re

f = open("input.txt", "r")
lines = f.readlines()

class Wire(object):
    def __init__(self, name):
        self.name = name
        self._value = None
        self.action = None
        self.children = []

    def add_action(self, action):
        self.action = action

    def set_children(self, *children):
        self.children = children

    def value(self):
        """ Returns a value as an int"""
        if self._value is None:
            self._value = self.action(*[ c.value() for c in self.children ]) % 65536
        return self._value

wires = {}

variable = "([a-z0-9]+)"

def var(s):
    return s.replace("var", variable)

NOT = re.compile(var("NOT var -> var"))
AND = re.compile(var("var AND var -> var"))
OR = re.compile(var("var OR var -> var"))
ASS = re.compile(var("var -> var"))
LSHIFT = re.compile(var("var LSHIFT (\d+) -> var"))
RSHIFT = re.compile(var("var RSHIFT (\d+) -> var"))

def goc(name):
    if not name in wires:
        wires[name] = Wire(name)

    wire = wires[name]
    try:
        value = int(name)
        wire._value = value
    except:
        pass

    return wires[name]

def not_(v1,v2):
    v1 = goc(v1)
    v2 = goc(v2)
    v2.add_action(lambda x: ~x)
    v2.set_children(v1)

def and_(v1,v2,v3):
    v1 = goc(v1)
    v2 = goc(v2)
    v3 = goc(v3)
    v3.add_action(lambda x,y: x & y)
    v3.set_children(v1,v2)

def or_(v1,v2,v3):
    v1 = goc(v1)
    v2 = goc(v2)
    v3 = goc(v3)
    v3.add_action(lambda x,y: x | y)
    v3.set_children(v1,v2)

def ass_(v1,v2):
    v1 = goc(v1)
    v2 = goc(v2)
    v2.add_action(lambda x: x)
    v2.set_children(v1)

def lshift_(v1,n,v2):
    v1 = goc(v1)
    v2 = goc(v2)
    n = int(n)
    v2.add_action(lambda x: x << n)
    v2.set_children(v1)

def rshift_(v1,n,v2):
    v1 = goc(v1)
    v2 = goc(v2)
    n = int(n)
    v2.add_action(lambda x: x >> n)
    v2.set_children(v1)

patterns = [NOT, AND, OR, ASS, LSHIFT, RSHIFT]
functions = [not_, and_, or_, ass_, lshift_, rshift_]

for l in lines:
    for p,f in zip(patterns,functions):
        m = p.match(l)
        if m is not None:
            f(*list(m.groups()))
            break

print(wires['a'].value())
