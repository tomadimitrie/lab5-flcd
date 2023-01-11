import Foundation

class Tree {
    let grammar: Grammar
    let sequence: [Int]
    lazy var root: Node = {
        let (key, tokens) = grammar.getProductionByIndex(sequence[0]).tuple
        return Node(value: key, child: buildRecursive(tokens: tokens))
    }()
    var depthIndex = 1
    
    init(grammar: Grammar, sequence: [Int]) {
        self.grammar = grammar
        self.sequence = sequence
    }
    
    func buildRecursive(tokens: [String], index: Int = 1) -> Node? {
        let isLastEpsilon = index == sequence.count && tokens.last == EPSILON
        let isEmptyOrExceededIndex = tokens.isEmpty || index >= sequence.count
        
        if !isLastEpsilon && isEmptyOrExceededIndex {
            return nil
        }
        
        let current = tokens[0]
        switch (current) {
        case _ where grammar.terminals.contains(current):
            return Node(
                value: current,
                sibling: buildRecursive(
                    tokens: Array(tokens.dropFirst()),
                    index: index
                )
            )
        case _ where grammar.nonterminals.contains(current):
            let transitionNumber = sequence[index]
            let (_, newTokens) = grammar.getProductionByIndex(transitionNumber).tuple
            
            return Node(
                value: current,
                child: buildRecursive(
                    tokens: newTokens,
                    index: index + 1
                ),
                sibling: buildRecursive(
                    tokens: Array(tokens.dropFirst()),
                    index: index + 1
                )
            )
        default:
            return Node(value: EPSILON)
        }
    }

    @discardableResult
    func bfs(
        node: Node?,
        output: inout String,
        fatherIndex: Int? = nil,
        siblingIndex: Int? = nil
    ) -> [Pair<Node?, Int>] {
        guard let node else {
            return []
        }
        let string = "\(depthIndex): \(node.value) \(fatherIndex.logable) \(siblingIndex.logable)\n"
        output += string

        let index = depthIndex
        depthIndex += 1

        let result = bfs(
            node: node.sibling,
            output: &output,
            fatherIndex: fatherIndex,
            siblingIndex: index
        ) + [Pair(node.child, index)]

        if siblingIndex != nil {
            return result
        }

        for pair in result {
            let (childNode, nodeIndex) = pair.tuple
            bfs(node: childNode, output: &output, fatherIndex: nodeIndex)
        }

        return []
    }
}

extension Tree: CustomDebugStringConvertible {
    public var debugDescription: String {
        root.description
    }
}

extension Tree: CustomStringConvertible {
    public var description: String {
        depthIndex = 1
        var result = ""
        bfs(node: root, output: &result)
        return result
    }
}