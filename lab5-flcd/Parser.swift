import Foundation
import Collections

class Parser {
    let grammar: Grammar

    lazy var first: FirstFunction = {
       FirstFunction(grammar: grammar)
    }()

    lazy var follow: FollowFunction = {
        FollowFunction(grammar: grammar, firstFunction: first)
    }()

    lazy var table: Table = {
       Table(grammar: grammar, first: first, follow: follow)
    }()

    init(grammar: Grammar) {
        self.grammar = grammar
    }

    func evaluate(sequence: [String]) -> [Int] {
        var inputStack = Deque<String>(sequence + [END_TERMINAL])
        var workingStack = Deque<String>([grammar.start, END_TERMINAL])
        var outputStack = Deque<Int>()

        while (!inputStack.isEmpty || !workingStack.isEmpty) {
            logStack(inputStack: inputStack, workingStack: workingStack, outputStack: outputStack)
            let inputStackFirst = inputStack.first!
            let workingStackFirst = workingStack.first!

            if (tryExecuteAccept(inputStackFirst: inputStackFirst, workingStackFirst: workingStackFirst)) {
                break
            }
            if (tryExecutePop(inputStack: &inputStack, workingStack: &workingStack)) {
                continue
            }
            expandWorkingStack(inputStackFirst: inputStackFirst, workingStack: &workingStack, outputStack: &outputStack)
        }
        return Array(outputStack)
    }

    func tryExecuteAccept(inputStackFirst: String, workingStackFirst: String) -> Bool {
        if inputStackFirst != END_TERMINAL || workingStackFirst != END_TERMINAL {
            return false
        }
        let tokens = table[workingStackFirst, inputStackFirst].first
        let operation = Operation(rawValue: tokens[0])
        return operation == .accept
    }

    func tryExecutePop(inputStack: inout Deque<String>, workingStack: inout Deque<String>) -> Bool {
        let inputStackFirst = inputStack.first!
        let workingStackFirst = workingStack.first!
        if inputStackFirst != workingStackFirst {
            return false
        }
        let tokens = table[workingStackFirst, inputStackFirst].first
        let operation = Operation(rawValue: tokens.first!)
        if operation != .pop {
            return false
        }
        inputStack.removeFirst()
        workingStack.removeFirst()
        return true
    }

    func expandWorkingStack(
        inputStackFirst: String,
        workingStack: inout Deque<String>,
        outputStack: inout Deque<Int>
    ) {
        let workingStackFirst = workingStack.first!
        let value = table[workingStackFirst, inputStackFirst]
        let tokens = value.first
        let index = value.second
        workingStack.removeFirst()
        workingStack.insert(contentsOf: tokens.filter { $0 != EPSILON }, at: 0)
        outputStack.append(index)
    }

    func logStack(
        inputStack: Deque<String>,
        workingStack: Deque<String>,
        outputStack: Deque<Int>
    ) {
        print("""
              Input: \(inputStack)
              Working: \(workingStack)
              Output: \(outputStack)

              """)
    }
}
