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

    func testAttackableSquares() {
        let piece = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.oneA] = piece

        XCTAssertEqual(board.attackableSuqares(from: .oneA), [.oneB, .twoA])
    }

    func testOccupiedSquares() {
        let piece1 = Piece(kind: .gold, color: .black)
        let piece2 = Piece(kind: .gold, color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.oneA] = piece1
        board[.oneB] = piece2
        board[.oneC] = piece3

        XCTAssertEqual(board.occupiedSquares(for: .black), [.oneA, .oneC])
    }

    func testEmptySquares() {
        var board = Board()

        XCTAssertEqual(board.emptySquares.count, 81)
        XCTAssertTrue(board.emptySquares.contains(.oneA))

        let piece = Piece(kind: .gold, color: .black)
        board[.oneA] = piece

        XCTAssertEqual(board.emptySquares.count, 80)
        XCTAssertFalse(board.emptySquares.contains(.oneA))
    }
}
