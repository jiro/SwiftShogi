public struct Piece {
    public enum Kind {
        case pawn(State)
        case lance(State)
        case knight(State)
        case silver(State)
        case gold
        case bishop(State)
        case rook(State)
        case king
    }

    public enum State {
        case normal
        case promoted
    }

    public private(set) var kind: Kind
    public private(set) var color: Color

    public init(kind: Kind, color: Color) {
        self.kind = kind
        self.color = color
    }
}

extension Piece {
    public var isPromoted: Bool {
        switch kind {
        case .pawn(.promoted),
             .lance(.promoted),
             .knight(.promoted),
             .silver(.promoted),
             .bishop(.promoted),
             .rook(.promoted):
            return true
        default:
            return false
        }
    }

    public var canPromote: Bool {
        switch kind {
        case .pawn(.normal),
             .lance(.normal),
             .knight(.normal),
             .silver(.normal),
             .bishop(.normal),
             .rook(.normal):
            return true
        default:
            return false
        }
    }
}

extension Piece.Kind: CaseIterable {
    public static let allCases: [Self] = [
        .pawn(.normal), .pawn(.promoted),
        .lance(.normal), .lance(.promoted),
        .knight(.normal), .knight(.promoted),
        .silver(.normal), .silver(.promoted),
        .gold,
        .bishop(.normal), .bishop(.promoted),
        .rook(.normal), .rook(.promoted),
        .king,
    ]
}

extension Piece: CaseIterable {
    public static let allCases: [Self] = kindsAndColors.map(Self.init)

    private static var kindsAndColors: [(Kind, Color)] {
        Kind.allCases.flatMap { kind in
            Color.allCases.map { color in (kind, color) }
        }
    }
}

extension Piece.Kind: Hashable {}
extension Piece: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
        hasher.combine(color)
    }
}
