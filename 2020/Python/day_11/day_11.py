from dataclasses import dataclass, field
from typing import List, Tuple, Set, Dict


def get_file_contents() -> List[str]:
    result: List[str] = []
    with open("day_11.txt", "r") as rf:
        for line in rf:
            result.append(line.strip())
    return result


@dataclass
class Seat:
    char: str
    sensitivity: int
    is_floor: bool = False
    is_occupied: bool = False
    is_occupied_next: bool = False
    did_change: bool = True
    occupied_neighbors: int = -1

    def __post_init__(self):
        if self.char == ".":
            self.is_floor = True
        elif self.char == "L":
            self.is_floor = False
            self.is_occupied = False
        elif self.char == "#":
            self.is_floor = False
            self.is_occupied = True

    @property
    def string(self) -> str:
        if self.is_floor:
            return "."
        elif self.is_occupied:
            return "#"
        else:
            return "L"

    def determine_next_state(self, occupied_adjacent_seats: int):
        self.occupied_neighbors = occupied_adjacent_seats
        if self.is_floor:
            self.did_change = False
        elif self.is_occupied is False and occupied_adjacent_seats == 0:
            self.is_occupied_next = True
        elif self.is_occupied and occupied_adjacent_seats >= self.sensitivity:
            self.is_occupied_next = False

    def update_state(self):
        if self.is_floor:
            self.did_change = False
            return

        if self.is_occupied != self.is_occupied_next:
            self.is_occupied = self.is_occupied_next
            self.did_change = True
        else:
            self.did_change = False

    def get_occupancy(self) -> bool:
        return self.is_occupied and not self.is_floor


@dataclass
class Plane:
    initial_config: List[Tuple[int, int, str]]
    visibility: int = 1
    sensitivity: int = 4
    # x, y tuple
    seats: Dict[Tuple[int, int], Seat] = field(default_factory=dict)

    def __post_init__(self):
        self.seats = {(t[0], t[1]): Seat(char=t[2], sensitivity=self.sensitivity) for t in self.initial_config}
        self.max_x = max(t[0] for t in self.seats.keys())
        self.max_y = max(t[1] for t in self.seats.keys())

    def get_occupied_adjacent_seats(self, pos_x: int, pos_y: int) -> int:
        adj_seats = 0
        for direction_to_check in ((-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)):
            if self._get_occupied_direction(direction=direction_to_check, pos_x=pos_x, pos_y=pos_y):
                adj_seats += 1
        return adj_seats

    def _get_occupied_direction(self, direction: Tuple[int, int], pos_x: int, pos_y: int) -> bool:
        for vis in range(1, self.visibility + 1):
            x_check = pos_x + direction[0] * vis
            y_check = pos_y + direction[1] * vis
            if 0 <= x_check <= self.max_x and 0 <= y_check <= self.max_y:
                if not self.seats[x_check, y_check].is_floor:
                    return self.seats[x_check, y_check].get_occupancy()
            else:
                return False
        return False

    def print_status(self):
        rep = ""
        for pos, seat in self.seats.items():
            if pos[0] == 0:
                rep += "\n"
            rep += str(seat.string)
        # print(rep)

    def print_occupied_neighbors(self):
        rep = ""
        for pos, seat in self.seats.items():
            if pos[0] == 0:
                rep += "\n"
            rep += str(seat.occupied_neighbors)
        # print(rep)

    def compute_static_seats(self) -> int:
        cycles = 0

        while any(seat.did_change for seat in self.seats.values()):
            self.print_status()
            cycles += 1
            for pos, seat in self.seats.items():
                seat.determine_next_state(
                    occupied_adjacent_seats=self.get_occupied_adjacent_seats(pos_x=pos[0], pos_y=pos[1]))
            self.print_occupied_neighbors()
            for seat in self.seats.values():
                seat.update_state()
        self.print_status()
        self.print_occupied_neighbors()
        print(f"{cycles=}")
        return len([s for s in self.seats.values() if s.get_occupancy()])


initial_config = []
for y, line in enumerate(get_file_contents()):
    for x, char in enumerate(line):
        initial_config.append((x, y, char))

plane_1 = Plane(initial_config=initial_config)
print(f"p1: {plane_1.compute_static_seats()}")

plane_2 = Plane(initial_config=initial_config, sensitivity=5, visibility=100)
print(f"p2: {plane_2.compute_static_seats()}")
