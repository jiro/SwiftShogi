public enum Color {
    case black
    case white
}

extension Color {
    public mutating func toggle() {
        self = isBlack ? .white : .black
    }

    private var isBlack: Bool { self == .black }
}

extension Color: CaseIterable {}
