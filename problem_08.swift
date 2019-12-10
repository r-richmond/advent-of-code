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

struct Layer {
  var width: Int
  var height: Int
  var lines: [String] = []

  init (value: String, width: Int, height: Int) {
    self.width = width
    self.height = height

    var tempValue: String
    var endIndex: String.Index
    for i in stride(from: 0, to: value.count, by: width) {
      if value.count < i + width {
        endIndex = value.endIndex
      } else {
        endIndex = value.index(value.startIndex, offsetBy: i + width)
      }

      tempValue = String(value[value.index(value.startIndex, offsetBy: i) ..< endIndex])
      self.lines.append(tempValue)
    }
  }
}

struct Image {
  var width: Int
  var height: Int
  var layers: [Layer] = []

  init(value: String, width: Int, height: Int) {
    self.width = width
    self.height = height

    var tempValue: String
    var endIndex: String.Index
    for i in stride(from: 0, to: value.count, by: width * height) {
      if value.count < i + width * height {
        endIndex = value.endIndex
      } else {
        endIndex = value.index(value.startIndex, offsetBy: i + width * height)
      }
      tempValue = String(value[value.index(value.startIndex, offsetBy: i) ..< endIndex])
      self.layers.append(Layer(value: tempValue, width: width, height: height))
    }
  }

  func findMinLayer(char: Character) -> Layer? {
    var minLayer : Layer = self.layers[0]
    var minLayerAmount = 10000
    var tempAmount: Int
    for layer in self.layers {
      tempAmount = 0
      for line in layer.lines {
        tempAmount += line.filter { $0 == char }.count
      }
      if tempAmount < minLayerAmount {
        minLayer = layer
        minLayerAmount = tempAmount
      } else if tempAmount == minLayerAmount {
        print("What to do with ties?")
        return nil
      }
    }
    return minLayer
  }

  // func renderResult() -> [String] {
  //   for line in self.lines {
  //
  //   }
  //   return ["hello"]
  // }
}

let messageTest = "123456789012"
let imageTest = Image(value: messageTest, width:3, height: 2)
var result : [String] = []
for layer in imageTest.layers {
  for line in layer.lines {
    result.append(line)
  }
}
print("the test found the expected result:", result == ["123", "456", "789", "012"])

let message = readFileFrom(path: "problem_08.txt")
let image = Image(value: message, width: 25, height: 6)

var minLayer = image.findMinLayer(char: "0")!

var minLayerOne = 0
var minLayerTwo = 0
for line in minLayer.lines {
  minLayerOne += line.filter { $0 == "1" }.count
  minLayerTwo += line.filter { $0 == "2" }.count
}
print("Part 1 answer = \(minLayerOne * minLayerTwo)")
