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

struct Person {
  var questions: Set<String>

  init (questions: Set<String>) {
    self.questions = questions
  }
}

class Group {
  var persons: [Person] = []

  init () {
  }

  func add(person: Person) {
    self.persons.append(person)
  }

  func anyone_answered() -> Int {
    var questions: Set<String> = []
    for person in self.persons {
      for question in person.questions {
        questions.update(with: question)
      }
    }
    return questions.count
  }

  func everyone_answered() -> Int {
    var questions: [String: Int] = [:]
    for person in self.persons {
      for question in person.questions {
        let current_value = questions[question]
        questions[question] = current_value == nil ? 1 : current_value! + 1
      }
    }

    var result = 0
    for (_, value) in questions {
      if value == self.persons.count {
        result += 1
      }
    }
    return result
  }

}

let contents = readFileFrom(path: "problem_06.txt")
var groups: [Group] = []

var group = Group()
for i in contents.components(separatedBy: "\n") {
  let line = String(i)
  if line == "" {
    groups.append(group)
    group = Group()
  } else {
    group.add(person: Person(questions: Set(line.map(String.init))))
  }
}
groups.append(group)

var total_anyone = 0
var total_everyone = 0
for g in groups {
  total_anyone += g.anyone_answered()
  total_everyone += g.everyone_answered()
}
print("\(groups.count) groups: \(total_anyone) questions anyone")
print("\(groups.count) groups: \(total_everyone) questions everyone")
