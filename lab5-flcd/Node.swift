import Foundation

class Node {
    let value: String
    let child: Node?
    let sibling: Node?
    
    init(value: String, child: Node? = nil, sibling: Node? = nil) {
        self.value = value
        self.child = child
        self.sibling = sibling
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        "Node(value: \(value), child: \(child), sibling: \(sibling))"
    }
}

extension Node: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    static func ==(lhs: Node, rhs: Node) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        if lhs.value != rhs.value {
            return false
        }
        return true
    }
}