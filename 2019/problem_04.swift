//https://stackoverflow.com/a/38215613
extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}

let start = 240920
let end = 789857

func is_increasing(_ i: Int) -> Bool {
  let t = String(i)
  var d_last = Int(t.prefix(1))!
  for d in t {
    if Int(String(d))! < d_last {
      return false
    }
    d_last = Int(String(d))!
  }
  return true
}

func is_pair_wise(_ i: Int) -> Bool {
  let t = String(i)
  var d_last = t.first
  for (i, d) in t.enumerated() {
    if i == 0 {
      continue
    }
    if d == d_last {
      return true
    }
    d_last = d
  }
  return false
}

func is_pair_wise_2(_ i: Int) -> Bool {
  let t = String(i)
  if t[0] == t[1] && t[1] != t[2] {
    return true
  } else if t[5] == t[4] && t[4] != t[3] {
    return true
  }
  for i in 1...4 {
    if t[i] == t[i+1] && t[i-1] != t[i] && t[i+1] != t[i+2] {
      return true
    }
  }
  return false
}

var total = 0
for n in start...end {
  if is_increasing(n) && is_pair_wise(n) {
    total += 1
  }
}

print("The answer for 4.1 is \(total)")

total = 0
for n in start...end {
  if is_increasing(n) && is_pair_wise(n) && is_pair_wise_2(n) {
    total += 1
  }
}

print("The answer for 4.2 is \(total)")
