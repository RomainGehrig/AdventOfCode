from string import ascii_lowercase

input_password = "hxbxxzaa"
numbers = { l: v for v,l in enumerate(ascii_lowercase) }
letters = { v: l for v,l in enumerate(ascii_lowercase) }
max_n = 26

def to_numbers(s):
    return [ numbers[l] for l in s ]

def to_letters(ns):
    return [ letters[n] for n in ns ]

def incr(ns):
    has_carry = True
    n = -1
    while has_carry:
        ns[n] += 1
        if ns[n] == max_n:
            ns[n] = 0
            n -= 1
        else:
            has_carry = False

invalid_nums = { numbers[l] for l in "lio" }
def is_valid(ns):
    double = 0
    just_doubled = False
    suite = False
    n_ = None
    n__ = None
    for n in ns:
        if n in invalid_nums:
            return False
        if n_ is not None:
            if n == n_ and not just_doubled:
                double += 1
                just_doubled = True
            else:
                just_doubled = False

            if n__ is not None:
                if n == n_ + 1 and n_ == n__ + 1:
                    suite = True
        n__ = n_
        n_ = n

    return double >= 2 and suite

if __name__ == '__main__':
    ns = to_numbers(input_password)
    while not is_valid(ns):
        incr(ns)

    print("Password:","".join(to_letters(ns)))
