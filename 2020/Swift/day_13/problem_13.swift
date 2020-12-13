import Foundation

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

class Requirement {
  let number: Int
  let position: Int
  var clicked: Bool = false

  init (number: Int, position: Int) {
    self.number = number
    self.position = position
    self.clicked = false
  }

  func check(answer: Int) -> Bool {
    return (answer + self.position) % self.number == 0
  }

}

let contents = readFileFrom(path: "day_13.txt")
var requirements: [Requirement] = []

for (i, num) in contents.components(separatedBy: "\n")[1].components(separatedBy: ",").enumerated() {
  if num != "x" {
    requirements.append(Requirement(number: Int(num)!, position: i))
  }
}

var answer = 0
var answer_incrementer = 1
var found_answer = false
var lengths: [Int] = []

while found_answer == false {
  if lengths.count < String(answer).count {
    lengths.append(answer)
    print(answer, Date())
  }

  for requirement in requirements {
    if requirement.check(answer: answer) {
      if requirement.clicked == false {
        requirement.clicked = true
        answer_incrementer = answer_incrementer * requirement.number
      }
    } else {
      found_answer = false
      answer += answer_incrementer
      break
    }
    found_answer = true
  }
}

print(answer)
