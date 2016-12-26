import re

class State(object):
    def __init__(self):
        reg = {}
        reg['a'] = 1
        reg['b'] = 0

        self.reg = reg
        self.addr = 0
        self.instr = []
        self.end = 0

    def add_instr(self, instr):
        self.instr.append(instr)
        self.end = len(self.instr)

    def __iter__(self):
        return self.iterable()

    def iterable(self):
        while self.addr < self.end:
            self.instr[self.addr](self)
            self.addr += 1
            yield self.reg

def hlf(reg):
    def apply(state):
        state.reg[reg] //= 2
    return apply

def tpl(reg):
    def apply(state):
        state.reg[reg] *= 3
    return apply

def inc(reg):
    def apply(state):
        state.reg[reg] += 1
    return apply

def jmp(offset):
    def apply(state):
        state.addr += int(offset) - 1
    return apply

def jie(reg,offset):
    def apply(state):
        if state.reg[reg] % 2 == 0:
            state.addr += int(offset) - 1
    return apply

def jio(reg,offset):
    def apply(state):
        if state.reg[reg] == 1:
            state.addr += int(offset) - 1
    return apply

one_arg_func_on_register = re.compile("(\S+) (\S)$")
jmp_func = re.compile("(jmp) ([+-]\d+)$")
jmp_with_register = re.compile("(\S+) (\S), ([+-]\d+)$")

instructions = {"hlf": hlf, "tpl": tpl, "inc": inc, "jmp": jmp, "jie": jie, "jio": jio}
regexes = [jmp_func, one_arg_func_on_register, jmp_with_register]

state_ = State()
with open("input.txt","r") as f:
    for l in f.readlines():
        for reg in regexes:
            m = reg.match(l)
            if m is not None:
                func, *args = m.groups()
                state_.add_instr(instructions[func](*args))
                break
        else:
            print("Line \"%s\" was not recognized" % l)

print(list(state_)[-1])
