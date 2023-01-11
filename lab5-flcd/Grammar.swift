import Foundation

let EPSILON = "ε"
let END_TERMINAL = "$"

class Grammar {
    let terminals: [String]
    let nonterminals: [String]
    let start: String
    var productions = [String: [[String]]]()
    var productionKeyOrder = [String]()

    init(filename: String) throws {
        let lines = try! String(contentsOfFile: filename).split(separator: "\n")
        terminals = lines[0]
            .split(separator: " ")
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        nonterminals = lines[1]
            .split(separator: " ")
            .map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        start = lines[2]
            .trimmingCharacters(in: .whitespacesAndNewlines)
        for line in lines[3...] {
            let tokens = line
                .split(separator: "->")
                .map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            let key = tokens[0]
            let values = tokens[1]
                .split(separator: "|")
                .map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            productionKeyOrder.append(key)
            productions[key] = values.map {
                $0.split(separator: " ").map {
                    String($0)
                }
            }
        }

        if !nonterminals.contains(start) {
            throw "nonterminals do not contain the start"
        }
        for (key, value) in productions {
            if !nonterminals.contains(key) {
                throw "nonterminals do not contain the key \(key)"
            }
            for choice in value {
                for component in choice {
                    if !nonterminals.contains(component) && !terminals.contains(component) && component != EPSILON {
                        throw "neither nonterminals not terminals contain \(component)"
                    }
                }
            }
        }
    }

    var productionsInOrder: [Pair<String, [[String]]>] {
        productionKeyOrder.map {
            Pair($0, productions[$0]!)
        }
    }

    func getProductionByIndex(_ index: Int) -> Pair<String, [String]> {
        let productions = productionsInOrder
            .flatMap { pair in
                let (key, tokens) = pair.tuple
                return tokens.map {
                    Pair(key, $0)
                }
            }
        if !(1...productions.count).contains(index) {
            print("Index \(index) not in range")
            fatalError()
        }
        return productions[index - 1]
    }
}

extension Grammar: CustomStringConvertible {
    var description: String {
        """
        Nonterminals: \(nonterminals)
        Terminals: \(terminals)
        Productions: \(productions)
        Start: \(start)

        """
    }
}
