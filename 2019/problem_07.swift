let op_code = [3,8,1001,8,10,8,105,1,0,0,21,42,67,84,109,122,203,284,365,446,99999,3,9,1002,9,3,9,1001,9,5,9,102,4,9,9,1001,9,3,9,4,9,99,3,9,1001,9,5,9,1002,9,3,9,1001,9,4,9,102,3,9,9,101,3,9,9,4,9,99,3,9,101,5,9,9,1002,9,3,9,101,5,9,9,4,9,99,3,9,102,5,9,9,101,5,9,9,102,3,9,9,101,3,9,9,102,2,9,9,4,9,99,3,9,101,2,9,9,1002,9,3,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,99]

func process(_ op_code: [Int], input: Int, phaseSetting: Int) -> [Int] {
  var result: [Int] = []
  var pos = 0
  var inputs_grabbed = 0
  let inputs = [phaseSetting, input]
  var op_codes = op_code

  var instruction: Int
  var param_mode_1: Int
  var param_mode_2: Int

  var param_1: Int
  var param_2: Int

  processLoop: while true {
      instruction = op_codes[pos] % 100
      param_mode_1 = op_codes[pos] / 100 % 10
      param_mode_2 = op_codes[pos] / 1000 % 10
      // param_mode_3 = op_codes[pos] / 10000 % 10

    switch instruction {
    case 1:
      param_1 = (param_mode_1 == 0 ? op_codes[op_codes[pos+1]] : op_codes[pos+1])
      param_2 = (param_mode_2 == 0 ? op_codes[op_codes[pos+2]] : op_codes[pos+2])
      op_codes[op_codes[pos+3]] = param_1 + param_2
      // print("\(param_1 ) + \(param_2) stored to \(op_codes[pos+3])")
      pos += 4
    case 2:
      param_1 = (param_mode_1 == 0 ? op_codes[op_codes[pos+1]] : op_codes[pos+1])
      param_2 = (param_mode_2 == 0 ? op_codes[op_codes[pos+2]] : op_codes[pos+2])
      op_codes[op_codes[pos+3]] = param_1 * param_2
      // print("\(param_1 ) * \(param_2) stored to \(op_codes[pos+3])")
      pos += 4
    case 3:
      op_codes[op_codes[pos+1]] = inputs[inputs_grabbed]
      inputs_grabbed += 1
      // print("\(input ) stored to \(op_codes[pos+1])")
      pos += 2
    case 4:
      param_1 = (param_mode_1 == 0 ? op_codes[op_codes[pos+1]] : op_codes[pos+1])
      // print(param_1)
      result.append(param_1)
      pos += 2
    case 5:
      param_1 = (param_mode_1 == 0 ? op_codes[op_codes[pos+1]] : op_codes[pos+1])
      param_2 = (param_mode_2 == 0 ? op_codes[op_codes[pos+2]] : op_codes[pos+2])
      if param_1 != 0 {
        pos = param_2
      } else {
        pos += 3
      }
    case 6:
      param_1 = (param_mode_1 == 0 ? op_codes[op_codes[pos+1]] : op_codes[pos+1])
      param_2 = (param_mode_2 == 0 ? op_codes[op_codes[pos+2]] : op_codes[pos+2])
      if param_1 == 0 {
        pos = param_2
      } else {
        pos += 3
      }
    case 7:
      param_1 = (param_mode_1 == 0 ? op_codes[op_codes[pos+1]] : op_codes[pos+1])
      param_2 = (param_mode_2 == 0 ? op_codes[op_codes[pos+2]] : op_codes[pos+2])
      op_codes[op_codes[pos+3]] = (param_1 < param_2 ? 1 : 0)
      pos += 4
    case 8:
      param_1 = (param_mode_1 == 0 ? op_codes[op_codes[pos+1]] : op_codes[pos+1])
      param_2 = (param_mode_2 == 0 ? op_codes[op_codes[pos+2]] : op_codes[pos+2])
      op_codes[op_codes[pos+3]] = (param_1 < param_2 ? 1 : 0)
      op_codes[op_codes[pos+3]] = (param_1 == param_2 ? 1 : 0)
      pos += 4
    case 99:
      break processLoop
    default:
      print("Error Unknown Instructioned Encountered")
      break processLoop
    }
  }
  return result
}

func processEngine(amplifier: [Int], op_code: [Int]) -> Int {
  let start = 0
  let result_a = process(op_code, input: start, phaseSetting: amplifier[0])
  let result_b = process(op_code, input: result_a[0], phaseSetting: amplifier[1])
  let result_c = process(op_code, input: result_b[0], phaseSetting: amplifier[2])
  let result_d = process(op_code, input: result_c[0], phaseSetting: amplifier[3])
  let result_e = process(op_code, input: result_d[0], phaseSetting: amplifier[4])
  // print("\(result_e[0]) and \(amplifier)")
  return result_e[0]
}

let op_code_test = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
print("43210 = \(processEngine(amplifier: [4,3,2,1,0], op_code: op_code_test))")

let op_code_test_2 = [3,23,3,24,1002,24,10,24,1002,23,-1,23,
101,5,23,23,1,24,23,23,4,23,99,0,0]
print("54321 = \(processEngine(amplifier: [0,1,2,3,4], op_code: op_code_test_2))")

let op_code_test_3 = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
print("65210 = \(processEngine(amplifier: [1,0,4,3,2], op_code: op_code_test_3))")

func validCombo(_ i: Int) -> Bool {
  let tempString = String(i)
  if i < 10000 {
    return tempString.contains("1") && tempString.contains("2") && tempString.contains("3") && tempString.contains("4")
  } else {
    return tempString.contains("0") && tempString.contains("1") && tempString.contains("2") &&  tempString.contains("3") && tempString.contains("4")
  }
}

var max = 0
var max_i = 0
var temp : Int
var tries = 0
for i in 1234...43210 {
  if !validCombo(i) {
    continue
  }
  tries += 1
  temp = processEngine(amplifier: [i/10000 % 10, i/1000 % 10, i/100 % 10, i/10 % 10, i/1 % 10], op_code: op_code)
  if temp > max {
    max = temp
    max_i = i
  }
}
print("Part 1 Max: \(max)", "amplifier: \(max_i)", "different simulations: \(120)")
