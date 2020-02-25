import Foundation

let op_code = [3,8,1001,8,10,8,105,1,0,0,21,42,67,84,109,122,203,284,365,446,99999,3,9,1002,9,3,9,1001,9,5,9,102,4,9,9,1001,9,3,9,4,9,99,3,9,1001,9,5,9,1002,9,3,9,1001,9,4,9,102,3,9,9,101,3,9,9,4,9,99,3,9,101,5,9,9,1002,9,3,9,101,5,9,9,4,9,99,3,9,102,5,9,9,101,5,9,9,102,3,9,9,101,3,9,9,102,2,9,9,4,9,99,3,9,101,2,9,9,1002,9,3,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,99]

class Computer {
  var memory: [Int]
  var memoryInitial: [Int]
  var input: [Int]
  var debug: Bool

  init(memory: [Int], input: [Int], debug: Bool=false) {
    // add some extra memory
    self.memory = memory + [Int](repeating: 0, count: 10000)
    self.memoryInitial = memory
    self.input = input
    self.debug = debug
  }

  func resetMemory() {
    self.memory = self.memoryInitial + [Int](repeating: 0, count: 10000)
  }

  func process() -> [Int] {
    var result: [Int] = []

    // used to track memory positions
    var pos = 0
    var pos_relative = 0
    var pos_input = 0
    // used in processing of instructions
    var instruction: Int
    var param_mode_1: Int
    var param_mode_2: Int
    var param_mode_3: Int
    var param_1: Int
    var param_2: Int
    var param_3: Int

    processLoop: while true {
      instruction = self.memory[pos] % 100
      param_mode_1 = self.memory[pos] / 100 % 10
      param_mode_2 = self.memory[pos] / 1000 % 10
      param_mode_3 = self.memory[pos] / 10000 % 10

      if instruction == 99 {
        break processLoop // dirty hack to prevent out of bounds memory
      }

      switch param_mode_1 {
      case 0: // memory mode
        param_1 = self.memory[pos+1]
      case 1: // direct mode
        param_1 = pos+1
      case 2: // relative mode
        param_1 = self.memory[pos+1] + pos_relative
      default:
        param_1 = 0
        print("unexpected error param_mode_1 = \(param_mode_1)")
        break
      }
      switch param_mode_2 {
      case 0:
        param_2 = self.memory[pos+2]
      case 1:
        param_2 = pos+2
      case 2:
        param_2 = self.memory[pos+2] + pos_relative
      default:
        param_2 = 0
        print("unexpected error param_mode_2 = \(param_mode_2)")
        break
      }
      switch param_mode_3 {
      case 0:
        param_3 = self.memory[pos+3]
      case 1:
        param_3 = pos+3
      case 2:
        param_3 = self.memory[pos+3] + pos_relative
      default:
        param_3 = 0
        print("unexpected error param_mode_3 = \(param_mode_3)")
        break
      }

      if self.debug {
        print("pos:\(pos) instruction:\(instruction)")
      }

      switch instruction {
      case 1: // add
        self.memory[param_3] = self.memory[param_1] + self.memory[param_2]
        pos += 4
      case 2: // multiply
        self.memory[param_3] = self.memory[param_1] * self.memory[param_2]
        pos += 4
      case 3: // store input
        if pos_input == self.input.count {
          print("more inputs requested than provided")
          pos_input -= 1
          // break processLoop
        }
        self.memory[param_1] = self.input[pos_input]
        pos_input += 1
        pos += 2
      case 4: // store result
        result.append(self.memory[param_1])
        pos += 2
      case 5: // jump-if-true (if p1 != 0 move to param_2)
        if self.memory[param_1] != 0 {
          pos = self.memory[param_2]
        } else {
          pos += 3
        }
      case 6: // jump-if-false (if p1 == 0 move to param_2)
        if self.memory[param_1] == 0 {
          pos = self.memory[param_2]
        } else {
          pos += 3
        }
      case 7: // less than
        self.memory[param_3] = (self.memory[param_1] < self.memory[param_2] ? 1 : 0)
        pos += 4
      case 8: // equals (if p1 == p2 then store 1 at p3 else 0 at p3)
        self.memory[param_3] = (self.memory[param_1] == self.memory[param_2] ? 1 : 0)
        pos += 4
      case 9: // modify relative pos
        pos_relative += self.memory[param_1]
        pos += 2
      case 99: // exit
        break processLoop
      default:
        print("Error Unknown Instructioned Encountered")
        break processLoop
      }
    }
    return result
  }
}

func validComboPart1(_ i: Int) -> Bool {
  let tempString = String(i)
  if i < 10000 {
    return tempString.contains("1") && tempString.contains("2") && tempString.contains("3") && tempString.contains("4")
  } else {
    return tempString.contains("0") && tempString.contains("1") && tempString.contains("2") &&  tempString.contains("3") && tempString.contains("4")
  }
}

func validComboPart2(_ i: Int) -> Bool {
  let tempString = String(i)
  return tempString.contains("5") && tempString.contains("6") && tempString.contains("7") &&  tempString.contains("8") && tempString.contains("9")
}

func processEngine(amplifier: [Int], op_code: [Int], loopMode:Bool=false) -> Int {

  let ComputerA = Computer(memory: op_code, input: [amplifier[0]] + [0])
  var resultA = ComputerA.process()
  let ComputerB = Computer(memory: op_code, input: [amplifier[1]] + resultA)
  var resultB = ComputerB.process()
  let ComputerC = Computer(memory: op_code, input: [amplifier[2]] + resultB)
  var resultC = ComputerC.process()
  let ComputerD = Computer(memory: op_code, input: [amplifier[3]] + resultC)
  var resultD = ComputerD.process()
  let ComputerE = Computer(memory: op_code, input: [amplifier[4]] + resultD)
  var resultE = ComputerE.process()
  while loopMode {
    ComputerA.input = [amplifier[0]] + resultE
    resultA = ComputerA.process()
    if resultA == [] {
      break
    }
    ComputerB.input = [amplifier[1]] + resultA
    resultB = ComputerB.process()
    if resultB == [] {
      break
    }
    ComputerC.input = [amplifier[2]] + resultB
    resultC = ComputerC.process()
    if resultC == [] {
      break
    }
    ComputerD.input = [amplifier[3]] + resultC
    resultD = ComputerD.process()
    if resultD == [] {
      break
    }
    ComputerE.input = [amplifier[4]] + resultD
    resultE = ComputerD.process()
  }
  return resultE[0]
}


var max = 0
var max_i = 0
var temp : Int
for i in 1234...43210 {
  if !validComboPart1(i) {
    continue
  }
  temp = processEngine(amplifier: [i/10000 % 10, i/1000 % 10, i/100 % 10, i/10 % 10, i/1 % 10], op_code: op_code)
  if temp > max {
    max = temp
    max_i = i
  }
}
print("Part 1 Max: \(max)", "amplifier: \(max_i)")

max = 0
max_i = 0
for i in 56789...98765 {
  if !validComboPart2(i) {
    continue
  }
  temp = processEngine(amplifier: [i/10000 % 10, i/1000 % 10, i/100 % 10, i/10 % 10, i/1 % 10], op_code: op_code, loopMode:true)
  if temp > max {
    max = temp
    max_i = i
  }
}
print("Part 2 Max: \(max)", "amplifier: \(max_i)")
