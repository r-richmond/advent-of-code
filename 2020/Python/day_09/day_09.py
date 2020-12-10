from dataclasses import dataclass
from typing import List


def determine_if_valid(number: int, numbers: List[int]) -> bool:
    for i1 in numbers:
        for i2 in numbers:
            if i1 == i2:
                continue
            if i1 + i2 == number:
                return True
    return False


@dataclass(frozen=True)
class DataStream:
    numbers: List[int]
    preamble: int

    def find_first_invalid(self) -> int:
        for i, number in enumerate(self.numbers):
            if i <= self.preamble - 1:
                continue
            is_valid = determine_if_valid(number=number, numbers=self.numbers[i-self.preamble:i])
            if not is_valid:
                return number

    def find_hack(self, invalid: int) -> int:
        attempt = 0
        while True:
            number = 0
            numbers = []
            for i, number_i in enumerate(self.numbers):
                if i < attempt:
                    continue
                number += number_i
                numbers.append(number_i)
                if number == invalid:
                    return min(numbers) + max(numbers)
                if number > invalid:
                    attempt += 1
                    break


initial_numbers = []
with open("2020/day_09.txt", "r") as rf:
    for i, line in enumerate(rf):
        initial_numbers.append(int(line.strip()))

data_stream = DataStream(preamble=25, numbers=initial_numbers)
print(data_stream.find_first_invalid())
print(data_stream.find_hack(invalid=data_stream.find_first_invalid()))