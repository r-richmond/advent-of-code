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

struct Id {
  var raw_data: String
  var raw_values: [String: String]

  init (raw_data: String) {
    self.raw_data = raw_data
    var raw_values: [String: String] = [:]
    for part in self.raw_data.components(separatedBy: " ") {
      raw_values[String(part[0..<3])] = String(part[4..<part.count])
    }
    self.raw_values = raw_values
  }

  func is_valid() -> Bool {
    let required_portions = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] // , "cid"
    var result = true
    for rq in required_portions {
      result = result && self.raw_data.contains(rq)
    }
    return result
  }

  func is_valid_2() -> Bool {
    // byr (Birth Year) - four digits; at least 1920 and at most 2002.
    // iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    // eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    // hgt (Height) - a number followed by either cm or in:
    // If cm, the number must be at least 150 and at most 193.
    // If in, the number must be at least 59 and at most 76.
    // hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    // ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    // pid (Passport ID) - a nine-digit number, including leading zeroes.
    let is_byr: Bool = self.raw_values["byr"] != nil && 1920 <= Int(self.raw_values["byr"]!)! && 2002 >= Int(self.raw_values["byr"]!)!
    let is_iyr: Bool = self.raw_values["iyr"] != nil && 2010 <= Int(self.raw_values["iyr"]!)! && 2020 >= Int(self.raw_values["iyr"]!)!
    let is_eyr: Bool = self.raw_values["eyr"] != nil && 2020 <= Int(self.raw_values["eyr"]!)! && 2030 >= Int(self.raw_values["eyr"]!)!
    var is_hgt: Bool = false
    if let hgt_value = self.raw_values["hgt"] {
      let allowed_suffixes = ["cm", "in"]
      if allowed_suffixes.contains(where: hgt_value.contains) {
        let hgt_value_num = Int(String(hgt_value[0..<hgt_value.count - 2]))!
        if hgt_value.hasSuffix("cm") {
          is_hgt = hgt_value_num >= 150 && hgt_value_num <= 193
        }
        if hgt_value.hasSuffix("in") {
          is_hgt = hgt_value_num >= 59 && hgt_value_num <= 76
        }
      }
    }
    var is_hcl: Bool = false
    if let hcl_value = self.raw_values["hcl"] {
      let values: Set<String> = Set(hcl_value.map(String.init))
      is_hcl = hcl_value.hasPrefix("#") && hcl_value.count == 7
      is_hcl = is_hcl && values.isSubset(of: Set(["#", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "a", "b", "c", "d", "e", "f"]))
    }
    var is_ecl: Bool = false
    if let ecl_value = self.raw_values["ecl"] {
      let allowed_ecl = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
      is_ecl = allowed_ecl.contains(where: ecl_value.contains)
    }
    var is_pid: Bool = false
    if let pid_value = self.raw_values["pid"] {
      if let _ = Int(pid_value) {
        is_pid = pid_value.count == 9
      }
    }
    return is_byr && is_iyr && is_eyr && is_hgt && is_hcl && is_ecl && is_pid
  }

}

let contents = readFileFrom(path: "problem_04.txt")
var ids: [Id] = []

var raw_data = ""
for i in contents.components(separatedBy: "\n") {
  let line = String(i)
  if line == "" {
    ids.append(Id(raw_data: raw_data))
    raw_data = ""
  } else {
    if raw_data != "" {
      raw_data += " "
    }
    raw_data += line
  }
}
ids.append(Id(raw_data: raw_data))

var total_1 = 0
var total_2 = 0
for id in ids {
  if id.is_valid() {
    total_1 += 1
  }
  if id.is_valid_2() {
    total_2 += 1
  }
}
print("total p1: \(total_1) total p2: \(total_2)")
