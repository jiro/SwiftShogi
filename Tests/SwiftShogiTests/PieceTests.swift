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

    func testPromote() {
        let kinds: [(kind: Piece.Kind, expectedKind: Piece.Kind)] = [
            (.pawn(.normal), .pawn(.promoted)),
            (.pawn(.promoted), .pawn(.promoted)),
            (.lance(.normal), .lance(.promoted)),
            (.lance(.promoted), .lance(.promoted)),
            (.knight(.normal), .knight(.promoted)),
            (.knight(.promoted), .knight(.promoted)),
            (.silver(.normal), .silver(.promoted)),
            (.silver(.promoted), .silver(.promoted)),
            (.gold, .gold),
            (.bishop(.normal), .bishop(.promoted)),
            (.bishop(.promoted), .bishop(.promoted)),
            (.rook(.normal), .rook(.promoted)),
            (.rook(.promoted), .rook(.promoted)),
            (.king, .king),
        ]
        kinds.forEach {
            var piece = Piece(kind: $0.kind, color: .black)
            piece.promote()

            let expected = Piece(kind: $0.expectedKind, color: .black)
            XCTAssertEqual(piece, expected)
        }
    }

    func testUnpromote() {
        let kinds: [(kind: Piece.Kind, expectedKind: Piece.Kind)] = [
            (.pawn(.normal), .pawn(.normal)),
            (.pawn(.promoted), .pawn(.normal)),
            (.lance(.normal), .lance(.normal)),
            (.lance(.promoted), .lance(.normal)),
            (.knight(.normal), .knight(.normal)),
            (.knight(.promoted), .knight(.normal)),
            (.silver(.normal), .silver(.normal)),
            (.silver(.promoted), .silver(.normal)),
            (.gold, .gold),
            (.bishop(.normal), .bishop(.normal)),
            (.bishop(.promoted), .bishop(.normal)),
            (.rook(.normal), .rook(.normal)),
            (.rook(.promoted), .rook(.normal)),
            (.king, .king),
        ]
        kinds.forEach {
            var piece = Piece(kind: $0.kind, color: .black)
            piece.unpromote()

            let expected = Piece(kind: $0.expectedKind, color: .black)
            XCTAssertEqual(piece, expected)
        }
    }

    func testCapture() {
        var piece = Piece(kind: .rook(.promoted), color: .black)
        piece.capture(by: .white)

        let expected = Piece(kind: .rook(.normal), color: .white)
        XCTAssertEqual(piece, expected)
    }

    func testAttacks() {
        let blackPieces: [(piece: Piece, expectedArray: [Piece.Attack])] = [
            (Piece(kind: .pawn(.normal), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: false),
            ]),
            (Piece(kind: .lance(.promoted), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: false),
                Piece.Attack(direction: .south, isFarReaching: false),
                Piece.Attack(direction: .east, isFarReaching: false),
                Piece.Attack(direction: .west, isFarReaching: false),
                Piece.Attack(direction: .northEast, isFarReaching: false),
                Piece.Attack(direction: .northWest, isFarReaching: false),
            ]),
            (Piece(kind: .lance(.normal), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: true),
            ]),
            (Piece(kind: .lance(.promoted), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: false),
                Piece.Attack(direction: .south, isFarReaching: false),
                Piece.Attack(direction: .east, isFarReaching: false),
                Piece.Attack(direction: .west, isFarReaching: false),
                Piece.Attack(direction: .northEast, isFarReaching: false),
                Piece.Attack(direction: .northWest, isFarReaching: false),
            ]),
            (Piece(kind: .knight(.normal), color: .black), [
                Piece.Attack(direction: .northNorthEast, isFarReaching: false),
                Piece.Attack(direction: .northNorthWest, isFarReaching: false),
            ]),
            (Piece(kind: .knight(.promoted), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: false),
                Piece.Attack(direction: .south, isFarReaching: false),
                Piece.Attack(direction: .east, isFarReaching: false),
                Piece.Attack(direction: .west, isFarReaching: false),
                Piece.Attack(direction: .northEast, isFarReaching: false),
                Piece.Attack(direction: .northWest, isFarReaching: false),
            ]),
            (Piece(kind: .silver(.normal), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: false),
                Piece.Attack(direction: .northEast, isFarReaching: false),
                Piece.Attack(direction: .northWest, isFarReaching: false),
                Piece.Attack(direction: .southEast, isFarReaching: false),
                Piece.Attack(direction: .southWest, isFarReaching: false),
            ]),
            (Piece(kind: .silver(.promoted), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: false),
                Piece.Attack(direction: .south, isFarReaching: false),
                Piece.Attack(direction: .east, isFarReaching: false),
                Piece.Attack(direction: .west, isFarReaching: false),
                Piece.Attack(direction: .northEast, isFarReaching: false),
                Piece.Attack(direction: .northWest, isFarReaching: false),
            ]),
            (Piece(kind: .gold, color: .black), [
                Piece.Attack(direction: .north, isFarReaching: false),
                Piece.Attack(direction: .south, isFarReaching: false),
                Piece.Attack(direction: .east, isFarReaching: false),
                Piece.Attack(direction: .west, isFarReaching: false),
                Piece.Attack(direction: .northEast, isFarReaching: false),
                Piece.Attack(direction: .northWest, isFarReaching: false),
            ]),
            (Piece(kind: .bishop(.normal), color: .black), [
                Piece.Attack(direction: .northEast, isFarReaching: true),
                Piece.Attack(direction: .northWest, isFarReaching: true),
                Piece.Attack(direction: .southEast, isFarReaching: true),
                Piece.Attack(direction: .southWest, isFarReaching: true),
            ]),
            (Piece(kind: .bishop(.promoted), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: false),
                Piece.Attack(direction: .south, isFarReaching: false),
                Piece.Attack(direction: .east, isFarReaching: false),
                Piece.Attack(direction: .west, isFarReaching: false),
                Piece.Attack(direction: .northEast, isFarReaching: true),
                Piece.Attack(direction: .northWest, isFarReaching: true),
                Piece.Attack(direction: .southEast, isFarReaching: true),
                Piece.Attack(direction: .southWest, isFarReaching: true),
            ]),
            (Piece(kind: .rook(.normal), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: true),
                Piece.Attack(direction: .south, isFarReaching: true),
                Piece.Attack(direction: .east, isFarReaching: true),
                Piece.Attack(direction: .west, isFarReaching: true),
            ]),
            (Piece(kind: .rook(.promoted), color: .black), [
                Piece.Attack(direction: .north, isFarReaching: true),
                Piece.Attack(direction: .south, isFarReaching: true),
                Piece.Attack(direction: .east, isFarReaching: true),
                Piece.Attack(direction: .west, isFarReaching: true),
                Piece.Attack(direction: .northEast, isFarReaching: false),
                Piece.Attack(direction: .northWest, isFarReaching: false),
                Piece.Attack(direction: .southEast, isFarReaching: false),
                Piece.Attack(direction: .southWest, isFarReaching: false),
            ]),
            (Piece(kind: .king, color: .black), [
                Piece.Attack(direction: .north, isFarReaching: false),
                Piece.Attack(direction: .south, isFarReaching: false),
                Piece.Attack(direction: .east, isFarReaching: false),
                Piece.Attack(direction: .west, isFarReaching: false),
                Piece.Attack(direction: .northEast, isFarReaching: false),
                Piece.Attack(direction: .northWest, isFarReaching: false),
                Piece.Attack(direction: .southEast, isFarReaching: false),
                Piece.Attack(direction: .southWest, isFarReaching: false),
            ]),
        ]
        blackPieces.forEach {
            XCTAssertEqual($0.piece.attacks, Set($0.expectedArray))
        }

        let whitePieces: [(piece: Piece, expectedArray: [Piece.Attack])] = [
            (Piece(kind: .lance(.normal), color: .white), [
                Piece.Attack(direction: .south, isFarReaching: true),
            ]),
        ]
        whitePieces.forEach {
            XCTAssertEqual($0.piece.attacks, Set($0.expectedArray))
        }
    }
}
