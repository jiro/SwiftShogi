public enum Color: CaseIterable {
    case black
    case white
}

extension Color {
    public var isBlack: Bool { self == .black }

    public mutating func toggle() {
        self = isBlack ? .white : .black
    }

    public func toggled() -> Self {
        var color = self
        color.toggle()
        return color
    }
}

extension Color {
    init?(character: Character) {
        switch character {
        case "b": self = .black
        case "w": self = .white
        default: return nil
        }
    }
}

extension Color: Comparable {
    public static func < (lhs: Color, rhs: Color) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}
