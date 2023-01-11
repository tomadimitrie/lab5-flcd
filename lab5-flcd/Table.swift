import Foundation

class Table {
    let grammar: Grammar
    let first: FirstFunction
    let follow: FollowFunction

    var data = [Pair < String, String>: Pair<[String], Int>]()

    init(grammar: Grammar, first: FirstFunction, follow: FollowFunction) {
        self.grammar = grammar
        self.first = first
        self.follow = follow

        grammar.productionsInOrder
            .flatMap { pair in
                let (rowSymbol, tokenList) = pair.tuple
                return tokenList.map {
                    Pair(rowSymbol, $0)
                }
            }
            .enumerated()
            .flatMap { (index, record) in
                let (rowSymbol, tokens) = record.tuple
                return mapToEntries(index: index + 1, rowSymbol: rowSymbol, tokens: tokens)
            }
            .forEach {
                plusAssign(data: $0)
            }

        fillPop()
        setAccept()
    }

    subscript(row: String, column: String) -> Pair<[String], Int> {
        get {
            guard let value = data[Pair(row, column)] else {
                print("Sequence not accepted: \(row) \(column) not in parsing table")
                fatalError()
            }
            return value
        }
        set {
            let key = Pair(row, column)
            if data.keys.contains(key) {
                print("failed to insert \(newValue): (\(row), \(column)) already in table: value = \(data[key]!)")
                fatalError()
            }
            data[key] = newValue
        }
    }

    func plusAssign(data: TableData) {
        self[data.rowSymbol, data.columnSymbol] = Pair(data.tokens, data.index)
    }

    func setAccept() {
        self[END_TERMINAL, END_TERMINAL] = Pair([Operation.accept.rawValue], -1)
    }

    func fillPop() {
        for terminal in grammar.terminals {
            self[terminal, terminal] = Pair([Operation.pop.rawValue], -1)
        }
    }

    func mapToEntries(index: Int, rowSymbol: String, tokens: [String]) -> [TableData] {
        if tokens.first == EPSILON {
            return follow[rowSymbol].map {
                TableData(rowSymbol: rowSymbol, columnSymbol: $0, tokens: tokens, index: index)
            }
        } else {
            return first.getConcatenationOfOne(tokens: tokens)
                .map {
                    TableData(rowSymbol: rowSymbol, columnSymbol: $0, tokens: tokens, index: index)
                }
        }
    }
}