from typing import List, Tuple, Set, Dict


def get_file_contents() -> List[str]:
    result: List[str] = []
    with open("day_10.txt", "r") as rf:
        for line in rf:
            result.append(line.strip())
    return result


def get_jolt_adapters() -> List[int]:
    result = [0]
    result.extend([int(i) for i in get_file_contents()])
    result.append(max(result) + 3)
    return sorted(result)


def evaluate(ja: List[int]) -> (bool, int, int, int):
    jump_1 = 0
    jump_2 = 0
    jump_3 = 0

    for i in range(len(ja)):
        if i == 0:
            continue
        delta = ja[i] - ja[i - 1]
        if delta == 1:
            jump_1 += 1
        elif delta == 2:
            jump_2 += 1
        elif delta == 3:
            jump_3 += 1
        else:
            return False, -1, -1, -1
    return True, jump_1, jump_2, jump_3


def is_valid(ja: List[int]) -> bool:
    for i in range(len(ja)):
        if i == 0:
            continue
        delta = ja[i] - ja[i - 1]
        if delta > 3:
            return False
    return True


def count_arrangements(al: List[int]) -> int:
    # for each number remove it and test if valid
    # if valid increase by one and test each of the remaining numbers
    arrangements: Set[Tuple[int]] = set()

    def process(a: List[int]):
        if is_valid(ja=a) and tuple(i for i in a) not in arrangements:
            arrangements.add(tuple(i for i in a))
            for i in range(len(a)):
                if i in (0, len(a)-1):
                    continue
                a2 = a[0:i] + a[i+1:]
                process(a2)
        else:
            pass
    process(al)
    return len(arrangements)


def break_up(a: List[int]) -> List[List[int]]:
    # split up input into parts we can't break
    result = []
    temp = []
    for n in a:
        if len(temp) == 0:
            temp.append(n)
        elif n - temp[-1] == 3:
            result.append(temp)
            temp = []
            temp.append(n)
        else:
            temp.append(n)
    result.append(temp)
    return result


print(f"part 1: {evaluate(ja=get_jolt_adapters())}")
initial = get_jolt_adapters()
# print(break_up(a=initial))
result = 1
arrangement_groups = []
for group in break_up(a=initial):
    unique = count_arrangements(group)
    # print(group, unique)
    result = result * unique
print(f"part 2: {result}")


# "smart solution"
memory: Dict[int, int] = dict()
for n in initial[::-1]:
    if n == max(initial):
        memory[n] = 1
    else:
        memory[n] = 0
        for n2 in [i for i in initial if n < i <= n + 3]:
            memory[n] += memory[n2]

print(f"part 2: {memory[min(initial)]} (smart way)")
