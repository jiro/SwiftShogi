public enum Color {
    case black
    case white
}

extension Color {
    public var isBlack: Bool { self == .black }

    public mutating func toggle() {
        self = isBlack ? .white : .black
    }
}

extension Color: CaseIterable {}
