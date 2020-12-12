from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List


def get_file_contents() -> List[str]:
    result: List[str] = []
    with open("day_12.txt", "r") as rf:
        for line in rf:
            result.append(line.strip())
    return result


class Direction(Enum):
    NORTH = auto()
    EAST = auto()
    SOUTH = auto()
    WEST = auto()
    LEFT = auto()
    RIGHT = auto()
    FORWARD = auto()


@dataclass
class Instruction:
    raw: str
    direction: Direction = None
    amount: int = 0
    turn_amount: int = 0

    def __post_init__(self):
        str_to_direction = {
            "N": Direction.NORTH,
            "E": Direction.EAST,
            "S": Direction.SOUTH,
            "W": Direction.WEST,
            "L": Direction.LEFT,
            "R": Direction.RIGHT,
            "F": Direction.FORWARD,
        }
        self.direction = str_to_direction[self.raw[0]]
        self.amount = int(self.raw[1:])
        if self.direction in (Direction.LEFT, Direction.RIGHT):
            self.turn_amount = self.amount // 90


@dataclass
class Person:
    pos_x: int = 0
    pos_y: int = 0
    facing: Direction = Direction.EAST
    # x, y
    waypoint: List[int] = field(default_factory=list)

    def __post_init__(self):
        self.waypoint = [10, 1]

    def move(self, instruction: Instruction):
        if instruction.direction == Direction.NORTH:
            self.pos_y += instruction.amount
        elif instruction.direction == Direction.EAST:
            self.pos_x += instruction.amount
        elif instruction.direction == Direction.SOUTH:
            self.pos_y -= instruction.amount
        elif instruction.direction == Direction.WEST:
            self.pos_x -= instruction.amount
        elif instruction.direction == Direction.FORWARD:
            if self.facing == Direction.NORTH:
                self.pos_y += instruction.amount
            elif self.facing == Direction.EAST:
                self.pos_x += instruction.amount
            elif self.facing == Direction.SOUTH:
                self.pos_y -= instruction.amount
            elif self.facing == Direction.WEST:
                self.pos_x -= instruction.amount
            else:
                raise ValueError("lost")
        elif instruction.direction == Direction.LEFT:
            self.turn_left(amount=instruction.turn_amount)
        elif instruction.direction == Direction.RIGHT:
            right_to_left = {1: 3, 2: 2, 3: 1, 0: 0}
            self.turn_left(amount=right_to_left.get(instruction.turn_amount))
        else:
            raise ValueError("lost 3")

    def turn_left(self, amount: int):
        for _ in range(amount):
            if self.facing == Direction.NORTH:
                self.facing = Direction.WEST
            elif self.facing == Direction.EAST:
                self.facing = Direction.NORTH
            elif self.facing == Direction.SOUTH:
                self.facing = Direction.EAST
            elif self.facing == Direction.WEST:
                self.facing = Direction.SOUTH
            else:
                raise ValueError("lost 2")

    def move_relative_to_waypoint(self, instruction: Instruction):
        if instruction.direction == Direction.NORTH:
            self.waypoint[1] += instruction.amount
        elif instruction.direction == Direction.EAST:
            self.waypoint[0] += instruction.amount
        elif instruction.direction == Direction.SOUTH:
            self.waypoint[1] -= instruction.amount
        elif instruction.direction == Direction.WEST:
            self.waypoint[0] -= instruction.amount
        elif instruction.direction == Direction.FORWARD:
            self.pos_x += self.waypoint[0] * instruction.amount
            self.pos_y += self.waypoint[1] * instruction.amount
        elif instruction.direction == Direction.LEFT:
            self.rotate_waypoint_left(amount=instruction.turn_amount)
        elif instruction.direction == Direction.RIGHT:
            right_to_left = {1: 3, 2: 2, 3: 1, 0: 0}
            self.rotate_waypoint_left(amount=right_to_left.get(instruction.turn_amount))
        else:
            raise ValueError("lost 3")

    def rotate_waypoint_left(self, amount: int):
        for _ in range(amount):
            new_x = self.waypoint[1] * -1
            new_y = self.waypoint[0] * 1
            self.waypoint[0] = new_x
            self.waypoint[1] = new_y


instructions = [Instruction(raw=r) for r in get_file_contents()]

person = Person()
for instruction in instructions:
    person.move(instruction=instruction)

print(person, abs(person.pos_x) + abs(person.pos_y))

person = Person()
for instruction in instructions:
    person.move_relative_to_waypoint(instruction=instruction)

print(person, abs(person.pos_x) + abs(person.pos_y))
