public enum Color: CaseIterable {
    case black
    case white
}

extension Color {
    public var isBlack: Bool { self == .black }

    public mutating func toggle() {
        self = isBlack ? .white : .black
    }
}

extension Color: Comparable {
    public static func < (lhs: Color, rhs: Color) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}
