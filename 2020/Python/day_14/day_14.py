from dataclasses import dataclass
from typing import List, Dict
import re


def get_file_contents() -> List[str]:
    result: List[str] = []
    with open("day_14.txt", "r") as rf:
        for li in rf:
            result.append(li.strip())
    return result


@dataclass
class BitMask:
    position: int
    value: int


@dataclass
class Memory:
    value: int = 0

    def apply_value(self, value: int, masks: List[BitMask]):
        value_string = f"{value:036b}"
        value_string = "0" * (36 - len(value_string)) + value_string
        for mask in masks:
            value_string = (
                value_string[: mask.position]
                + str(mask.value)
                + value_string[mask.position + 1 :]
            )
        self.value = int(value_string, base=2)


memory_address: Dict[int, Memory] = {}
bit_masks: List[BitMask] = []

for line in get_file_contents():
    if line[0:4] == "mask":
        bit_masks = []
        for pos, char in enumerate(line[7:]):
            if char in ("0", "1"):
                bit_masks.append(BitMask(position=pos, value=int(char)))
    elif line[0:3] == "mem":
        address = int(re.findall(r"mem\[(\d*)]", line)[0])
        value = int(re.findall(r"] = (\d*)", line)[0])
        current_memory = memory_address.get(address, Memory(value=0))
        current_memory.apply_value(value=value, masks=bit_masks)
        memory_address[address] = current_memory
    else:
        print(line)

total = 0
for memory in memory_address.values():
    total += memory.value
    print(memory, f"{memory.value:036b}")

print(total)
