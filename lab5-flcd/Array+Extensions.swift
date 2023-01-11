extension Array where Element: Equatable {
    func excluding(element: Element) -> Self {
        Self(dropFirst(firstIndex(of: element)! + 1))
    }
}