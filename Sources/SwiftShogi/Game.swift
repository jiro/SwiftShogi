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

        remove(move.piece, from: move.source)
        insert(move.piece, to: move.destination)

        color.toggle()
    }

    private mutating func remove(_ piece: Piece, from source: Move.Source) {
        switch source {
        case let .board(square):
            board[square] = nil
        case .capturedPiece:
            let index = capturedPieces.firstIndex(of: piece)!
            capturedPieces.remove(at: index)
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

    /// An error in move validation.
    public enum MoveValidationError: Error {
        case boardPieceDoesNotExist
        case capturedPieceDoesNotExist
        case invalidPieceColor
        case friendlyPieceAlreadyExists
        case illegalAttack
        case pieceAlreadyPromoted
        case pieceCannotPromote
        case illegalBoardPiecePromotion
        case illegalCapturedPiecePromotion
    }

    /// Validates `move`.
    public func validate(_ move: Move) throws {
        try validateSource(move.source, piece: move.piece)
        try validateDestination(move.destination)
        try validateAttack(source: move.source, destination: move.destination)
        if move.shouldPromote {
            try validatePromotion(
                source: move.source,
                destination: move.destination,
                piece: move.piece
            )
        }
    }

    private func validateSource(_ source: Move.Source, piece: Piece) throws {
        switch source {
        case let .board(square):
            guard board[square] == piece else {
                throw MoveValidationError.boardPieceDoesNotExist
            }
        case .capturedPiece:
            guard capturedPieces.contains(piece) else {
                throw MoveValidationError.capturedPieceDoesNotExist
            }
        }

        guard piece.color == color else {
            throw MoveValidationError.invalidPieceColor
        }
    }

    private func validateDestination(_ destination: Move.Destination) throws {
        switch destination {
        case let .board(square):
            // If a piece at the destination does not exist, no validation is required
            guard let piece = board[square] else { return }

            guard piece.color != color else {
                throw MoveValidationError.friendlyPieceAlreadyExists
            }
        }
    }

    private func validateAttack(source: Move.Source, destination: Move.Destination) throws {
        switch (source, destination) {
        case let (.board(sourceSquare), .board(destinationSquare)):
            guard board.isValidAttack(from: sourceSquare, to: destinationSquare) else {
                throw MoveValidationError.illegalAttack
            }
        case (.capturedPiece, _):
            break
        }
    }

    private func validatePromotion(source: Move.Source, destination: Move.Destination, piece: Piece) throws {
        guard !piece.isPromoted else {
            throw MoveValidationError.pieceAlreadyPromoted
        }
        guard piece.canPromote else {
            throw MoveValidationError.pieceCannotPromote
        }

        switch (source, destination) {
        case let (.board(sourceSquare), .board(destinationSquare)):
            let squares = Square.promotableCases(for: color)
            guard squares.contains(where: { $0 == sourceSquare || $0 == destinationSquare }) else {
                throw MoveValidationError.illegalBoardPiecePromotion
            }
        case (.capturedPiece, _):
            throw MoveValidationError.illegalCapturedPiecePromotion
        }
    }
}
