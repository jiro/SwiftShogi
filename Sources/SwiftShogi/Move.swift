public struct Move {
    public enum Source {
        case board(Square)
        case capturedPiece
    }

    public enum Destination {
        case board(Square)
    }

    public let source: Source
    public let destination: Destination
    public let piece: Piece
    public let shouldPromote: Bool

    public init(source: Source, destination: Destination, piece: Piece, shouldPromote: Bool = false) {
        self.source = source
        self.destination = destination
        self.piece = piece
        self.shouldPromote = shouldPromote
    }
}

extension Move.Source: Equatable {}
extension Move.Destination: Equatable {}
extension Move: Equatable {}
