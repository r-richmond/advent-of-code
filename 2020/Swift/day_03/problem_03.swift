import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
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

struct Position {
  var has_tree: Bool

  init (has_tree: Bool) {
    self.has_tree = has_tree
  }
}

struct Row {
  var positions: [Position]

  init (positions: [Position]) {
    self.positions = positions
  }

  init (raw_data_line: String) {
    self.positions = []
    for char in  raw_data_line {
      self.positions.append(Position(has_tree: char == "#"))
    }
  }

  func dense_visual() -> String {
    var dense: [String] = []
    for position in self.positions {
      if position.has_tree {
        dense.append("#")
      } else {
        dense.append(".")
      }
    }
    return dense.joined(separator: "")
  }
}

struct Map {
  let rows: [Row]

  init (raw_data: String) {
    var rows: [Row] = []
    for line in raw_data.split(separator: "\n") {
      rows.append(Row(raw_data_line: String(line)))
    }
    self.rows = rows
  }

  init (rows: [Row]) {
    self.rows = rows
  }

  func count_tree_impacts(x_value: Int, y_value: Int) -> Int {
    var current_x = 0
    var current_y = 0
    var impacts = 0
    var positions: [Position]
    while current_y + y_value < self.rows.count {
      current_x += x_value
      current_y += y_value
      positions = self.rows[current_y].positions
      // print(
      //   String(format:" %2.0d", current_x), 
      //   String(format:" %2.0d", current_y),
      //   positions[(current_x + 0) % positions.count].has_tree ? "#" : ".",
      //   self.rows[current_y].dense_visual()
      //   )
      if positions[(current_x + 0) % positions.count].has_tree {
        impacts += 1
      }
    }
    return impacts
  }
}

let contents = readFileFrom(path: "problem_03.txt")

var map = Map(raw_data: contents)

var answer_1_1 = map.count_tree_impacts(x_value: 1, y_value: 1)
var answer_3_1 = map.count_tree_impacts(x_value: 3, y_value: 1)
var answer_5_1 = map.count_tree_impacts(x_value: 5, y_value: 1)
var answer_7_1 = map.count_tree_impacts(x_value: 7, y_value: 1)
var answer_1_2 = map.count_tree_impacts(x_value: 1, y_value: 2)

print("problem_1: \(answer_3_1)")

print("problem_2: \(answer_1_1 * answer_3_1 * answer_5_1 * answer_7_1 * answer_1_2)")
