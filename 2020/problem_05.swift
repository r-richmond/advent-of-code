import Foundation

public extension String {
  subscript(value: Int) -> Character {
    self[index(at: value)]
  }
}

public extension String {
  subscript(value: NSRange) -> Substring {
    self[value.lowerBound..<value.upperBound]
  }
}

public extension String {
  subscript(value: CountableClosedRange<Int>) -> Substring {
    self[index(at: value.lowerBound)...index(at: value.upperBound)]
  }

  subscript(value: CountableRange<Int>) -> Substring {
    self[index(at: value.lowerBound)..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeUpTo<Int>) -> Substring {
    self[..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeThrough<Int>) -> Substring {
    self[...index(at: value.upperBound)]
  }

  subscript(value: PartialRangeFrom<Int>) -> Substring {
    self[index(at: value.lowerBound)...]
  }
}

private extension String {
  func index(at offset: Int) -> String.Index {
    index(startIndex, offsetBy: offset)
  }
}

func readFileFrom(path: String, ignoreTrailingNewLine: Bool = true) -> String {
  do {
      // Get the contents
      if ignoreTrailingNewLine {
        var contents = try String(contentsOfFile: path, encoding: .utf8)
        contents = contents.trimmingCharacters(in: .whitespacesAndNewlines)
        return contents
      } else {
        let contents = try String(contentsOfFile: path, encoding: .utf8)
        return contents
      }
  }
  catch let error as NSError {
      return "Ooops! Something went wrong: \(error)"
  }
}

struct BoardingPass {
  var value: String
  var row: Int = 0
  var column: Int = 0
  var id: Int = 0

  init (value: String) {
    self.value = value
    let row_value = String(value[0...6])
    let col_value = String(value[7...9])
    for (n, rv) in row_value.enumerated() {
      if rv == "B" {
        self.row += 2 << (5 - n)
      }
    }
    for (n, cv) in col_value.enumerated() {
      if cv == "R" {
        self.column += 2 << (1 - n)
      }
    }
    self.id = self.row * 8 + self.column
  }
}


let contents = readFileFrom(path: "problem_05.txt")
var max_value = 0
var ids: [Int] = []

for i in contents.components(separatedBy: "\n") {
  let line = String(i)
  let boarding_pass = BoardingPass(value: line)
  if boarding_pass.id >= max_value {
    max_value = boarding_pass.id
  }
  ids.append(boarding_pass.id)
}

print(max_value)
ids.sort()
for (i, id) in ids.enumerated() {
  if i == 0 {
    continue
  } else {
    if ids[i - 1] != id - 1 {
      print(id - 1)
    }
  }
}
