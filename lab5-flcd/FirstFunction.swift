import Foundation

class FirstFunction {
    let grammar: Grammar
    lazy var map: [String: Set<String>] = {
        grammar.nonterminals.reduce(into: [String: Set<_>]()) {
            $0[$1] = Set<_>()
        }
    }()
    
    init(grammar: Grammar) {
        self.grammar = grammar

        for key in grammar.productions.keys {
            getOrCreate(key: key)
        }
    }

    @discardableResult
    func getOrCreate(key: String) -> Set<String> {
        let existing = self[key]
        if !existing.isEmpty {
            return existing
        }
        guard let productions = grammar.productions[key] else {
            print("key \(key) not found in productions")
            fatalError()
        }
        for production in productions {
            add(key: key, tokens: computeConcatenationOfOne(tokens: production))
        }
        return self[key]
    }
    
    subscript(key: String) -> Set<String> {
        get {
            if key == EPSILON || grammar.terminals.contains(key) {
                return Set<_>([key])
            } else {
                guard let value = map[key] else {
                    print("key \(key) not found in non terminals")
                    fatalError()
                }
                return Set<_>(value)
            }
        }
    }
    
    subscript(tokens: [String]) -> Set<String> {
        Set<_>(tokens.flatMap { self[$0] })
    }
    
    func add(key: String, tokens: Set<String>) {
        map[key]!.formUnion(tokens)
    }
    
    func computeConcatenationOfOne(tokens: [String]) -> Set<String> {
        if tokens.isEmpty {
            return Set<_>()
        }
        let firstToken = tokens[0]
        if tokens.count < 2 {
            return getOrCreate(key: firstToken)
        }
        var values = getOrCreate(key: firstToken)
        if !values.contains(EPSILON) {
            return values
        }
        values.remove(EPSILON)
        return values.union(computeConcatenationOfOne(tokens: Array(tokens.dropFirst())))
    }

    func getConcatenationOfOne(tokens: [String]) -> Set<String> {
        if tokens.isEmpty {
            return Set<_>()
        }
        let firstToken = tokens[0]
        if tokens.count < 2 {
            return self[firstToken]
        }
        var values = self[firstToken]
        if !values.contains(EPSILON) {
            return values
        }
        values.remove(EPSILON)
        return values.union(computeConcatenationOfOne(tokens: Array(tokens.dropFirst())))
    }
}
