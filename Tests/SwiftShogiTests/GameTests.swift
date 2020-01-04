import XCTest
@testable import SwiftShogi

final class GameTests: XCTestCase {
    func testPerformFromBoard() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.oneA: piece])
        var game = Game(board: board)
        XCTAssertEqual(game.board[.oneA], piece)
        XCTAssertNil(game.board[.oneB])
        XCTAssertEqual(game.color, .black)
        XCTAssertTrue(game.capturedPieces.isEmpty)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece
        )
        XCTAssertNoThrow(try game.perform(move))

        XCTAssertNil(game.board[.oneA])
        XCTAssertEqual(game.board[.oneB], piece)
        XCTAssertEqual(game.color, .white)
        XCTAssertTrue(game.capturedPieces.isEmpty)
    }

    func testPerformFromCapturedPiece() {
        let piece = Piece(kind: .gold, color: .black)
        var game = Game(capturedPieces: [piece])
        XCTAssertNil(game.board[.oneA])
        XCTAssertEqual(game.color, .black)
        XCTAssertTrue(game.capturedPieces.contains(piece))

        let move = Move(
            source: .capturedPiece,
            destination: .board(.oneA),
            piece: piece
        )
        XCTAssertNoThrow(try game.perform(move))

        XCTAssertEqual(game.board[.oneA], piece)
        XCTAssertEqual(game.color, .white)
        XCTAssertTrue(game.capturedPieces.isEmpty)
    }

    func testValidateWithBoardPieceDoesNotExistMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [:])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .boardPieceDoesNotExist)
        }
    }

    func testValidateWithCapturedPieceDoesNotExistMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let game = Game(capturedPieces: [])

        let move = Move(
            source: .capturedPiece,
            destination: .board(.oneA),
            piece: piece
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .capturedPieceDoesNotExist)
        }
    }

    func testValidateWithInvalidPieceColorMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.oneA: piece])
        let game = Game(board: board, color: .white)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .invalidPieceColor)
        }
    }

    func testValidateWithFriendlyPieceAlreadyExistsMoveValidationError() {
        let piece1 = Piece(kind: .gold, color: .black)
        let piece2 = Piece(kind: .king, color: .black)
        let board = Board(pieces: [.oneA: piece1, .oneB: piece2])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece1
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .friendlyPieceAlreadyExists)
        }
    }

    func testValidateWithPieceAlreadyPromotedMoveValidationError() {
        let piece = Piece(kind: .rook(.promoted), color: .black)
        let board = Board(pieces: [.oneA: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece,
            shouldPromote: true
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .pieceAlreadyPromoted)
        }
    }

    func testValidateWithPieceCannotPromoteMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.oneA: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece,
            shouldPromote: true
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .pieceCannotPromote)
        }
    }

    func testValidateWithIllegalBoardPiecePromotionMoveValidationError() {
        let piece = Piece(kind: .rook(.normal), color: .black)
        let board = Board(pieces: [.oneI: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneI),
            destination: .board(.oneH),
            piece: piece,
            shouldPromote: true
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .illegalBoardPiecePromotion)
        }
    }

    func testValidateWithIllegalCapturedPiecePromotionMoveValidationError() {
        let piece = Piece(kind: .rook(.normal), color: .black)
        let game = Game(capturedPieces: [piece])

        let move = Move(
            source: .capturedPiece,
            destination: .board(.oneA),
            piece: piece,
            shouldPromote: true
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .illegalCapturedPiecePromotion)
        }
    }
}

private extension Board {
    init(pieces: [Square: Piece]) {
        self.init()
        pieces.forEach { square, piece in self[square] = piece }
    }
}
