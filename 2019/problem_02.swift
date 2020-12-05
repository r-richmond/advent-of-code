let op_code = [1, 0, 0, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 1, 10, 19, 1, 6, 19, 23, 1, 13, 23, 27, 1, 6, 27, 31, 1, 31, 10, 35, 1, 35, 6, 39, 1, 39, 13, 43, 2, 10, 43, 47, 1, 47, 6, 51, 2, 6, 51, 55, 1, 5, 55, 59, 2, 13, 59, 63, 2, 63, 9, 67, 1, 5, 67, 71, 2, 13, 71, 75, 1, 75, 5, 79, 1, 10, 79, 83, 2, 6, 83, 87, 2, 13, 87, 91, 1, 9, 91, 95, 1, 9, 95, 99, 2, 99, 9, 103, 1, 5, 103, 107, 2, 9, 107, 111, 1, 5, 111, 115, 1, 115, 2, 119, 1, 9, 119, 0, 99, 2, 0, 14, 0]

func process(_ op_code: [Int], val_1: Int, val_2: Int) -> [Int] {
  var pos = 0
  var op_codes = op_code
  op_codes[1] = val_1
  op_codes[2] = val_2
  while true {
    if op_codes[pos] == 1 {
      op_codes[op_codes[pos+3]] = op_codes[op_codes[pos+1]] + op_codes[op_codes[pos+2]]
    } else if op_codes[pos] == 2 {
      op_codes[op_codes[pos+3]] = op_codes[op_codes[pos+1]] * op_codes[op_codes[pos+2]]
    } else if op_codes[pos] == 99 {
      break
    }
    pos += 4
  }
  return op_codes
}

print("the result of part 1: \(process(op_code, val_1: 12, val_2: 2)[0])")

var r = 0
for i in 0...100 {
  for j in 0...100 {
    r = process(op_code, val_1: i, val_2: j)[0]
    if r == 19690720 {
      print("The result of part2: \(100 * i + j)")
    }
  }
}
