extension Optional {
    var logable: Any {
        switch self {
        case .none:
            return "nil"
        case let .some(value):
            return value
        }
    }
}