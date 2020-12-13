from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List
import math

def get_file_contents() -> List[str]:
    result: List[str] = []
    with open("day_13.txt", "r") as rf:
        for line in rf:
            result.append(line.strip())
    return result


def problem_1(t: List[str]) -> int:
    target = int(t[0])
    line_2_inputs = t[1].split(",")
    buses = [int(l2) for l2 in line_2_inputs if l2 != 'x']

    fastest_bus = -1
    shortest_wait = 10000000000
    for bus in buses:
        mult = (target // bus) + 1
        time = mult * bus - target
        # print(bus, target, mult, time)
        if time < shortest_wait:
            fastest_bus = bus
            shortest_wait = time
            # print(bus, time, shortest_wait)
        elif time == shortest_wait:
            raise ValueError

    # print(fastest_bus, shortest_wait)
    return fastest_bus * shortest_wait


@dataclass
class Requirement:
    number: int
    position: int
    clicked: bool = False

    def check(self, answer: int) -> bool:
        return (answer + self.position) % self.number == 0


def problem_2(requirements: List[Requirement]) -> int:
    answer = 0
    answer_inc = 1
    answer_found = False
    while not answer_found:
        for r in requirements:
            if r.check(answer=answer):
                if not r.clicked:
                    r.clicked = True
                    answer_inc = math.lcm(*[r.number for r in requirements if r.clicked])
            else:
                answer += answer_inc
                break
        answer_found = all(r.clicked for r in requirements)

    return answer


print(f"p1: {problem_1(t=get_file_contents())}")

raw = get_file_contents()[1]
requirements: List[Requirement] = [Requirement(number=int(i), position=pos) for pos, i in enumerate(raw.split(",")) if i != "x"]

print(f"p2: {problem_2(requirements=requirements)}")
