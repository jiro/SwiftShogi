import XCTest
@testable import SwiftShogi

final class PieceTests: XCTestCase {
    func testIsPromoted() {
        let kinds: [(kind: Piece.Kind, expected: Bool)] = [
            (.pawn(.normal), false),
            (.pawn(.promoted), true),
            (.lance(.normal), false),
            (.lance(.promoted), true),
            (.knight(.normal), false),
            (.knight(.promoted), true),
            (.silver(.normal), false),
            (.silver(.promoted), true),
            (.gold, false),
            (.bishop(.normal), false),
            (.bishop(.promoted), true),
            (.rook(.normal), false),
            (.rook(.promoted), true),
            (.king, false),
        ]
        kinds.forEach {
            let piece = Piece(kind: $0.kind, color: .black)
            XCTAssertEqual(piece.isPromoted, $0.expected)
        }
    }

    func testCanPromote() {
        let kinds: [(kind: Piece.Kind, expected: Bool)] = [
            (.pawn(.normal), true),
            (.pawn(.promoted), false),
            (.lance(.normal), true),
            (.lance(.promoted), false),
            (.knight(.normal), true),
            (.knight(.promoted), false),
            (.silver(.normal), true),
            (.silver(.promoted), false),
            (.gold, false),
            (.bishop(.normal), true),
            (.bishop(.promoted), false),
            (.rook(.normal), true),
            (.rook(.promoted), false),
            (.king, false),
        ]
        kinds.forEach {
            let piece = Piece(kind: $0.kind, color: .black)
            XCTAssertEqual(piece.canPromote, $0.expected)
        }
    }
}
