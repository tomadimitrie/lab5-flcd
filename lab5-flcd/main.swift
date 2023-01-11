import Foundation

for (file, function) in [
    ("/Users/toma/Downloads/lab5-flcd/lab5-flcd/inputs/g1.txt", parseSequence),
    ("/Users/toma/Downloads/lab5-flcd/lab5-flcd/inputs/g2.txt", parsePif),
] {
    let grammar = try! Grammar(filename: file)
    print(grammar.description)
    let parser = Parser(grammar: grammar)
    let sequence = function()
    let result = parser.evaluate(sequence: sequence)
    let tree = Tree(grammar: grammar, sequence: result)
    print(tree)
}

func parseSequence() -> [String] {
    var tokens = [String]()
    let contents = try! String(contentsOfFile: "/Users/toma/Downloads/lab5-flcd/lab5-flcd/inputs/seq.txt")
    for line in contents.split(separator: "\n") {
        tokens.append(contentsOf: String(line).split(separator: " ").map { String($0) })
    }
    return tokens
}

func parsePif() -> [String] {
    var tokens = [String]()
    let contents = try! String(contentsOfFile: "/Users/toma/Downloads/lab5-flcd/lab5-flcd/inputs/PIF.out")
    for line in contents.split(separator: "\n") {
        tokens.append(String(line.split(separator: "->")[0].trimmingCharacters(in: .whitespacesAndNewlines)))
    }
    return tokens
}