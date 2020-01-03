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
