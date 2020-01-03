public struct Game {
    public private(set) var board: Board
    public private(set) var color: Color
    public private(set) var capturedPieces: [Piece]

    public init(board: Board = Board(), color: Color = .black, capturedPieces: [Piece] = []) {
        self.board = board
        self.color = color
        self.capturedPieces = capturedPieces
    }
}

extension Game {

    /// Performs `move` with validating it.
    public mutating func perform(_ move: Move) throws {
        try validate(move)

        let sourcePiece = remove(from: move.source)
        insert(sourcePiece, to: move.destination)
    }

    private mutating func remove(from source: Move.Source) -> Piece {
        switch source {
        case let .board(square):
            let piece = board[square]!
            board[square] = nil
            return piece
        case let .capturedPiece(piece):
            let index = capturedPieces.firstIndex(of: piece)!
            capturedPieces.remove(at: index)
            return piece
        }
    }

    private mutating func insert(_ piece: Piece, to destination: Move.Destination) {
        switch destination {
        case let .board(square):
            board[square] = piece
        }
    }
}

extension Game {

    /// Validates `move`.
    public func validate(_ move: Move) throws {
    }
}
