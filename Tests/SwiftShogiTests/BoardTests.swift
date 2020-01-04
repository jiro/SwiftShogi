import XCTest
@testable import SwiftShogi

final class BoardTests: XCTestCase {
    func testSubscript() {
        let piece = Piece(kind: .gold, color: .black)
        var board = Board()
        XCTAssertNil(board[.oneA])

        board[.oneA] = piece
        XCTAssertEqual(board[.oneA], piece)

        board[.oneA] = nil
        XCTAssertNil(board[.oneA])
    }

    func testIsValidAttack() {
        let piece = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.oneA] = piece

        XCTAssertTrue(board.isValidAttack(from: .oneA, to: .oneB))
        XCTAssertFalse(board.isValidAttack(from: .oneA, to: .oneC))
        XCTAssertFalse(board.isValidAttack(from: .oneB, to: .oneC))
    }
}
