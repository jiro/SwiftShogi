import XCTest
@testable import SwiftShogi

final class GameTests: XCTestCase {
    func testPerformMoveFromBoard() {
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

    func testPerformMoveFromCapturedPiece() {
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
}

private extension Board {
    init(pieces: [Square: Piece]) {
        self.init()
        pieces.forEach { square, piece in self[square] = piece }
    }
}
