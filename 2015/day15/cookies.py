flavors = { "Sprinkles":    { "capacity":  5, "durability": -1, "flavor": 0, "texture": 0, "calories": 5 },
            "PeanutButter": { "capacity": -1, "durability":  3, "flavor": 0, "texture": 0, "calories": 1 },
            "Frosting":     { "capacity":  0, "durability": -1, "flavor": 4, "texture": 0, "calories": 6 },
            "Sugar":        { "capacity": -1, "durability":  0, "flavor": 0, "texture": 2, "calories": 8 }}

max_tablespoons = 100

ingredients = flavors.keys()

parameters = {"capacity", "durability", "flavor", "texture"}

def compute_score(sp, pb, fr, su):
    flav = [ (sp, flavors["Sprinkles"]),
             (pb, flavors["PeanutButter"]),
             (fr, flavors["Frosting"]),
             (su, flavors["Sugar"]) ]

    total = 1
    for p in parameters:
        param_total = 0
        for (n,d) in flav:
            param_total += n * d[p]
        if param_total <= 0:
            return 0
        else:
            total *= param_total

    return total

max_score = 0
for sprinkles in range(1, max_tablespoons):
    for peanutbutter in range(1, max_tablespoons - sprinkles):
        for frosting in range(1, max_tablespoons - sprinkles - peanutbutter):
            sugar = max_tablespoons - sprinkles - peanutbutter - frosting
            if sugar < 0:
                continue
            score = compute_score(sprinkles, peanutbutter, frosting, sugar)
            if score > max_score:
                print("Found new max score: %s (%s spr, %s pb, %s fr, %s su)" % (score, sprinkles, peanutbutter, frosting, sugar))
                max_score = score


print("Max score: %s" % max_score)
