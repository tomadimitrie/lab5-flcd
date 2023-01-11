class FollowFunction {
    let grammar: Grammar
    let firstFunction: FirstFunction
    lazy var map: [String: Set<String>] = {
        grammar.nonterminals.reduce(into: [String: Set<_>]()) {
            $0[$1] = Set<_>()
        }
    }()

    init(grammar: Grammar, firstFunction: FirstFunction) {
        self.grammar = grammar
        self.firstFunction = firstFunction

        getOrCreate(key: grammar.start)
        for nonterminal in grammar.nonterminals {
            getOrCreate(key: nonterminal)
        }
    }

    func analyzeToken(token: String) -> Set<String> {
        var followTokens: Set<String>
        if token == grammar.start {
            followTokens = Set([add(key: token, token: END_TERMINAL)])
        } else {
            followTokens = Set()
        }

        grammar.productions
            .flatMap { (key, values) in
                values.map {
                    Pair(key, $0)
                }
            }
            .filter { pair in
                let (key, sequence) = pair.tuple
                return key != token && sequence.contains(token)
            }
            .forEach { pair in
                let (key, sequence) = pair.tuple
                followTokens.formUnion(add(
                    key: token,
                    tokens: analyzeTokenSequence(
                        key: key,
                        token: token,
                        tokenSequence: sequence
                    )
                ))
            }
        return followTokens
    }

    func analyzeTokenSequence(key: String, token: String, tokenSequence: [String]) -> Set<String> {
        if tokenSequence.isEmpty {
            return Set()
        }
        if tokenSequence.last == token {
            return getOrCreate(key: key)
        }
        var rightOfToken = firstFunction[tokenSequence.excluding(element: token)]
        if !rightOfToken.contains(EPSILON) {
            return rightOfToken
        }
        rightOfToken.remove(EPSILON)
        return rightOfToken.union(getOrCreate(key: key))
    }

    subscript(key: String) -> Set<String> {
        guard let value = map[key] else {
            print("key \(key) not present in nonterminals")
            fatalError()
        }
        return value
    }

    func add(key: String, tokens: Set<String>) -> Set<String> {
        map[key]!.formUnion(tokens)
        return tokens
    }

    func add(key: String, token: String) -> String {
        map[key]!.insert(token)
        return token
    }

    @discardableResult
    func getOrCreate(key: String) -> Set<String> {
        let result = self[key]
        if !result.isEmpty {
            return result
        } else {
            return analyzeToken(token: key)
        }
    }
}