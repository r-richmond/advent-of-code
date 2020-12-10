from dataclasses import dataclass


@dataclass
class BagRule:
    id: str
    children: list[str]

    def __post_init__(self):
        self.unique_children = set(self.children)

    def does_contain_shiny_gold_bag(self) -> bool:
        if "shiny gold" in self.children:
            return True
        elif len(self.children) == 0:
            return False
        else:
            return any(bag_rule_lookup[c].does_contain_shiny_gold_bag() for c in self.unique_children)

    def count_sub_bags(self) -> int:
        if len(self.children) == 0:
            return 0
        else:
            result = len(self.children)
            for c in self.children:
                result += bag_rule_lookup[c].count_sub_bags()
            return result


def parse_bag_rule(t: str) -> BagRule:
    t0 = t.split(" contain ")
    id = t0[0].replace(" bags", "").replace(" bag", "")
    if t0[1] == "no other bags.":
        return BagRule(id=id, children=[])
    else:
        t1 = t0[1].split(sep=", ")
        t1[-1] = t1[-1].replace(".", "")
        child = []
        for r in t1:
            for _ in range(int(r[0])):
                child.append(r[2:].replace(" bags", "").replace(" bag", ""))
        return BagRule(id=id, children=child)


bag_rules: list[BagRule] = []
with open("day_07.txt", "r") as rf:
    for line in rf:
        bag_rule = parse_bag_rule(line.strip())
        bag_rules.append(bag_rule)

bag_rule_lookup: dict[str, BagRule] = {br.id: br for br in bag_rules}

total = 0
for br in bag_rules:
    if br.does_contain_shiny_gold_bag():
        # print(br.id, len(bag_rules))
        total += 1
    if br.id == "shiny gold":
        print(f"p2 shiny gold bags: {br.count_sub_bags()}")
print(f"p1 {total=}")
