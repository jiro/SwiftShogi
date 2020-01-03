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

        let move = Move(source: .board(.oneA), destination: .board(.oneB))
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

        let move = Move(source: .capturedPiece(piece), destination: .board(.oneA))
        XCTAssertNoThrow(try game.perform(move))

        XCTAssertEqual(game.board[.oneA], piece)
        XCTAssertEqual(game.color, .white)
        XCTAssertTrue(game.capturedPieces.isEmpty)
    }

    func testValidateWithBoardPieceDoesNotExistMoveError() {
        let board = Board(pieces: [:])
        let game = Game(board: board)

        let move = Move(source: .board(.oneA), destination: .board(.oneB))
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .boardPieceDoesNotExist)
        }
    }

    func testValidateWithCapturedPieceDoesNotExistMoveError() {
        let piece = Piece(kind: .gold, color: .black)
        let game = Game(capturedPieces: [])

        let move = Move(source: .capturedPiece(piece), destination: .board(.oneA))
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .capturedPieceDoesNotExist)
        }
    }

    func testValidateWithInvalidPieceColorMoveError() {
        let square = Square.oneA
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [square: piece])
        let game = Game(board: board, color: .white)

        let move = Move(source: .board(square), destination: .board(.oneB))
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .invalidPieceColor)
        }
    }
}

private extension Board {
    init(pieces: [Square: Piece]) {
        self.init()
        pieces.forEach { square, piece in self[square] = piece }
    }
}
