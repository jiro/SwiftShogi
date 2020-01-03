public struct Move {
    public enum Source {
        case board(Square)
        case capturedPiece(Piece)
    }

    public enum Destination {
        case board(Square)
    }

    public let source: Source
    public let destination: Destination
    public let shouldPromote: Bool

    public init(source: Source, destination: Destination, shouldPromote: Bool = false) {
        self.source = source
        self.destination = destination
        self.shouldPromote = shouldPromote
    }
}

extension Move.Source: Equatable {}
extension Move.Destination: Equatable {}
extension Move: Equatable {}
