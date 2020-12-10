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

struct PasswordRecord {
  var min_value: Int
  var max_value: Int
  var letter: Character
  var password: String

  init (min_value: Int, max_value: Int, letter: Character, password: String) {
    self.min_value = min_value
    self.max_value = max_value
    self.letter = letter
    self.password = password
  }

  func is_valid_password() -> Bool {
    let count = self.password.filter { $0 == self.letter}.count
    if count >= self.min_value && count <= self.max_value {
      return true
    } else {
      return false
    }
  }

  func is_valid_password_2() -> Bool {
    if self.password.count < self.max_value || self.password.count < self.min_value {
      return false
    }
    let pos1 = self.password[self.min_value - 1]
    let pos2 = self.password[self.max_value - 1]
    return (pos1 == self.letter) != (pos2 == self.letter)
  }

}

func parse_line(line: String) -> PasswordRecord {
  // 11-52 k: kkkkhkkkkkkkkkk
  var split = line.split(separator: ":")
  let password = String(split[1]).replacingOccurrences(of: " ", with: "")
  split = String(split[0]).split(separator: " ")
  let letter = Character(String(split[1]))
  split = String(split[0]).split(separator: "-")
  let min_value = Int(String(split[0]))!
  let max_value = Int(String(split[1]))!
  let result = PasswordRecord(
    min_value: min_value, 
    max_value: max_value, 
    letter: letter, 
    password: password)
  return result
}

let contents = readFileFrom(path: "problem_02.txt")

var valid_password_1: Int = 0
var valid_password_2: Int = 0
for i in contents.split(separator: "\n") {
  let password_record = parse_line(line: String(i))
  if password_record.is_valid_password() {
    valid_password_1 += 1
  }
  if password_record.is_valid_password_2(){
    valid_password_2 += 1
  }
}

print(valid_password_1, valid_password_2)
