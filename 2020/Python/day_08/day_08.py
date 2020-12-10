from dataclasses import dataclass
from typing import List


@dataclass
class GameCommand:
    pos: int
    command: str
    value_increment: int = 0
    pos_increment: int = 1
    increment: int = 0

    def switch_jmp_acc(self):
        if self.command.startswith("nop"):
            # switch to jmp
            self.value_increment = 0
            self.pos_increment = self.increment
        else:
            # switch to nmp
            self.value_increment = 0
            self.pos_increment = 1


def parse_command(pos: int, txt: str) -> GameCommand:
    if txt[0:3] == "nop":
        val = int(txt[4:])
        return GameCommand(pos, command=txt, increment=val)
    elif txt[0:3] == "acc":
        val = int(txt[4:])
        return GameCommand(pos, command=txt, value_increment=val)
    elif txt[0:3] == "jmp":
        val = int(txt[4:])
        return GameCommand(pos, command=txt, pos_increment=val)


def get_commands() -> List[GameCommand]:
    commands = []
    with open("2020/day_08.txt", "r") as rf:
        for i, line in enumerate(rf):
            command = parse_command(pos=i, txt=line.strip())
            commands.append(command)
    return commands


def evaluate_program(commands: List[GameCommand]) -> (bool, int):
    commands_executed = set()
    final_value = 0
    pos = 0
    correct = False
    while True:
        if pos >= len(commands):
            correct = True
            break
        command = commands[pos]
        if command.pos in commands_executed:
            break
        else:
            final_value += command.value_increment
            pos += command.pos_increment
            commands_executed.add(command.pos)
    return correct, final_value

print(f"part 1: {evaluate_program(commands=get_commands())}")
commands_num = len(get_commands())

for i in range(commands_num):
    commands_test = get_commands()
    commands_test[i].switch_jmp_acc()
    result = evaluate_program(commands=commands_test)
    if result[0]:
        print(f"part 2: {result}")

