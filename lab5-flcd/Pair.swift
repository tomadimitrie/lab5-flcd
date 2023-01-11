import Foundation

class Pair<T, U>: Hashable where T: Hashable, U: Hashable {
    let first: T
    let second: U

    init(_ first: T, _ second: U) {
        self.first = first
        self.second = second
    }

    static func ==(lhs: Pair<T, U>, rhs: Pair<T, U>) -> Bool {
        lhs.first == rhs.first && lhs.second == rhs.second
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(first)
        hasher.combine(second)
    }

    var tuple: (T, U) {
        (first, second)
    }
}

extension Pair: CustomStringConvertible {
    public var description: String {
        "(\(first), \(second)"
    }
}