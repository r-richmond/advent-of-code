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

class Planet {
  var id: String
  var parent_id: String
  var distance: Int

  init(id: String, parent_id: String) {
    self.id = id
    self.parent_id = parent_id
    self.distance = 0
  }

}

func processIntoDictPlanet(_ input: [String: String]) -> [String: Planet] {
  var result: [String: Planet] = [:]
  for (c, p) in input{
    result[c] = Planet(id: c, parent_id: p)
  }
  return result
}

let mappingPlanet = processIntoDictPlanet(mapping)

let yourPlanet = mappingPlanet["YOU"]!
let santaPlanet = mappingPlanet["SAN"]!
var currentDistance = -1
yourPlanet.distance = currentDistance
var currentPlanet = yourPlanet
while true {
  if mappingPlanet[currentPlanet.parent_id] != nil {
    currentPlanet = mappingPlanet[currentPlanet.parent_id]!
    currentDistance += 1
    currentPlanet.distance = currentDistance
  } else {
    break
  }
}

currentDistance = 0
currentPlanet = santaPlanet
var parentPlanet: Planet
var finalDistance : Int
while true {
  if mappingPlanet[currentPlanet.parent_id] != nil {
    parentPlanet = mappingPlanet[currentPlanet.parent_id]!
    if parentPlanet.distance == 0 {
      currentPlanet = mappingPlanet[currentPlanet.parent_id]!
      currentDistance += 1
      currentPlanet.distance = currentDistance
    } else {
      finalDistance = currentPlanet.distance + parentPlanet.distance
      print("Part 2: total distance of \(finalDistance) | \(currentPlanet.distance) + & \(parentPlanet.distance)")
      break
    }
  }
}
