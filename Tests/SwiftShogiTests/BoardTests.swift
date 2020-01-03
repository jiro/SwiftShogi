import XCTest
@testable import SwiftShogi

final class BoardTests: XCTestCase {
    func testSubscript() {
        let piece = Piece(kind: .king, color: .black)
        var board = Board()
        XCTAssertNil(board[.oneA])

        board[.oneA] = piece
        XCTAssertEqual(board[.oneA], piece)

        board[.oneA] = nil
        XCTAssertNil(board[.oneA])
    }
}
