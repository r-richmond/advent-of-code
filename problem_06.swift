import Foundation

func readFileFrom(path: String) -> String {
  do {
      // Get the contents
      let contents = try String(contentsOfFile: path, encoding: .utf8)
      return contents
  }
  catch let error as NSError {
      return "Ooops! Something went wrong: \(error)"
  }
}

func processIntoDict(_ contents: String) -> [String: String] {
  // returns a dict with key: child | value: parent
  var result: [String: String] = [:]
  var split: [String.SubSequence]
  for i in contents.split(separator: "\n") {
    split = i.split(separator: ")")
    result[String(split[1])] = String(split[0])
  }
  return result
}

// Set the file path
let contents = readFileFrom(path:"problem_06.txt")
let mapping = processIntoDict(contents)

var total = 0
var pt : String
for (_, p) in mapping {
  total += 1
  pt = p
  while mapping[pt] != nil {
    total += 1
    pt = mapping[pt]!
  }
}
print("Part 1: total direct and indirect orbits \(total)")
