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

    public mutating func promote() {
        switch kind {
        case .pawn(.normal): kind = .pawn(.promoted)
        case .lance(.normal): kind = .lance(.promoted)
        case .knight(.normal): kind = .knight(.promoted)
        case .silver(.normal): kind = .silver(.promoted)
        case .bishop(.normal): kind = .bishop(.promoted)
        case .rook(.normal): kind = .rook(.promoted)
        default: break
        }
    }

    public mutating func unpromote() {
        switch kind {
        case .pawn(.promoted): kind = .pawn(.normal)
        case .lance(.promoted): kind = .lance(.normal)
        case .knight(.promoted): kind = .knight(.normal)
        case .silver(.promoted): kind = .silver(.normal)
        case .bishop(.promoted): kind = .bishop(.normal)
        case .rook(.promoted): kind = .rook(.normal)
        default: break
        }
    }

    public mutating func capture(by color: Color) {
        unpromote()
        self.color = color
    }
}

extension Piece {
    struct Attack: Hashable {
        let direction: Direction
        let isFarReaching: Bool
    }

    var attacks: Set<Attack> {
        let directions = farReachingDirections
        let attacks = attackableDirections.map {
            Attack(direction: $0, isFarReaching: directions.contains($0))
        }
        return Set(attacks)
    }

    init?(character: Character, isPromoted: Bool) {
        let state: State = isPromoted ? .promoted : .normal
        switch character.lowercased() {
        case "p": self.kind = .pawn(state)
        case "l": self.kind = .lance(state)
        case "n": self.kind = .knight(state)
        case "s": self.kind = .silver(state)
        case "g": self.kind = .gold
        case "b": self.kind = .bishop(state)
        case "r": self.kind = .rook(state)
        case "k": self.kind = .king
        default: return nil
        }
        self.color = character.isUppercase ? .black : .white
    }
}

private extension Piece {
    var attackableDirections: [Direction] {
        let directions: [Direction] = {
            switch kind {
            case .pawn(.normal),
                 .lance(.normal):
                return [.north]
            case .knight(.normal):
                return [.northNorthEast, .northNorthWest]
            case .silver(.normal):
                return [.north, .northEast, .northWest, .southEast, .southWest]
            case .pawn(.promoted),
                 .lance(.promoted),
                 .knight(.promoted),
                 .silver(.promoted),
                 .gold:
                return [.north, .south, .east, .west, .northEast, .northWest]
            case .bishop(.normal):
                return [.northEast, .northWest, .southEast, .southWest]
            case .rook(.normal):
                return [.north, .south, .east, .west]
            case .bishop(.promoted),
                 .rook(.promoted),
                 .king:
                return [.north, .south, .east, .west, .northEast, .northWest, .southEast, .southWest]
            }
        }()
        return color.isBlack ? directions : directions.map { $0.flippedVertically }
    }

    var farReachingDirections: [Direction] {
        let directions: [Direction] = {
            switch kind {
            case .lance(.normal):
                return [.north]
            case .bishop:
                return [.northEast, .northWest, .southEast, .southWest]
            case .rook:
                return [.north, .south, .east, .west]
            default:
                return []
            }
        }()
        return color.isBlack ? directions : directions.map { $0.flippedVertically }
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

extension Piece.Kind: Comparable {
    public static func < (lhs: Piece.Kind, rhs: Piece.Kind) -> Bool {
        return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}

extension Piece.Kind: Hashable {}
extension Piece: Hashable {}
