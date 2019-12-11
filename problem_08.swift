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

  func renderString() -> [String] {
    var result: [String] = []
    for layer in self.layers {
      for line in layer.lines {
        result.append(line)
      }
    }
    return result
  }

  func calcResult() -> [String] {
    var result = [String](repeating: "2", count: self.width * self.height)
    var counter: Int
    for layer in self.layers {
      counter = 0
      for line in layer.lines {
        for char in line {
          if result[counter] == "2" {
            result[counter] = ( String(char) == "0" ? " " : String(char))
          }
          counter += 1
        }
      }
    }
    return result
  }

  func renderResult() {
    let rendered = self.calcResult()
    for i in stride(from: 0, to: rendered.count, by: width) {
      print(rendered[i..<i+width].joined(separator: ""))
    }
  }
}

let messageTest = "123456789012"
let imageTest = Image(value: messageTest, width:3, height: 2)
print("Test one passed:", imageTest.renderString() == ["123", "456", "789", "012"])

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

print("Part 2 hidden message: ")
image.renderResult()
