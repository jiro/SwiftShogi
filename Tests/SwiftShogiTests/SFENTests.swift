import XCTest
@testable import SwiftShogi

final class SFENTests: XCTestCase {
    func testInitializer() {
        XCTAssertNil(SFEN(string: "4k4/9/9/9/9/9/9/9/4K4"))

        let sfen = SFEN(string: "4k4/9/9/9/9/9/9/9/4K4 w G")!
        XCTAssertEqual(sfen.board[.fiveA], Piece(kind: .king, color: .white))
        XCTAssertEqual(sfen.board[.fiveI], Piece(kind: .king, color: .black))
        XCTAssertEqual(sfen.color, .white)
        XCTAssertEqual(sfen.capturedPieces, [Piece(kind: .gold, color: .black)])
    }
}

final class SFENComponentsTests: XCTestCase {
    func testBoard() {
        var fields: SFEN.Fields

        fields = SFEN.Fields(boardString: "4k4/9/9/9/9/9/9/9/4K4")!
        XCTAssertEqual(fields.board![.fiveA], Piece(kind: .king, color: .white))
        XCTAssertEqual(fields.board![.fiveI], Piece(kind: .king, color: .black))

        fields = SFEN.Fields(boardString: "9/9/9/9/9/9/9/9/4+R4")!
        XCTAssertEqual(fields.board![.fiveI], Piece(kind: .rook(.promoted), color: .black))

        let strings: [(string: String, expected: Board?)] = [
            ("9", nil),
            ("9/9/9/9/9/9/9/9/9K", nil),
            ("9/9/9/9/9/9/9/9/4K9", nil),
            ("9/9/9/9/9/9/9/9/4++R4", nil),
            ("9/9/9/9/9/9/9/9/4Z4", nil),
            ("9/9/9/9/9/9/9/9/1", nil),
        ]
        strings.forEach {
            let fields = SFEN.Fields(boardString: $0.string)!
            XCTAssertEqual(fields.board, $0.expected)
        }
    }

    func testColor() {
        let strings: [(string: String, expected: Color?)] = [
            ("b", .black),
            ("bw", nil),
            ("z", nil),
        ]
        strings.forEach {
            let fields = SFEN.Fields(colorString: $0.string)!
            XCTAssertEqual(fields.color, $0.expected)
        }
    }

    func testCapturedPieces() {
        let strings: [(string: String, expected: [Piece]?)] = [
            ("-", []),
            ("Pp", [
                Piece(kind: .pawn(.normal), color: .black),
                Piece(kind: .pawn(.normal), color: .white)
            ]),
            ("2P2p", [
                Piece(kind: .pawn(.normal), color: .black),
                Piece(kind: .pawn(.normal), color: .black),
                Piece(kind: .pawn(.normal), color: .white),
                Piece(kind: .pawn(.normal), color: .white)
            ]),
            ("+P+p", [
                Piece(kind: .pawn(.promoted), color: .black),
                Piece(kind: .pawn(.promoted), color: .white)
            ]),
            ("+P++p", nil),
            ("+P22p", nil),
            ("Pp+", nil),
            ("Pp2", nil),
            ("z", nil),
        ]
        strings.forEach {
            let fields = SFEN.Fields(capturedPiecesString: $0.string)!
            XCTAssertEqual(fields.capturedPieces, $0.expected)
        }
    }
}

private extension SFEN.Fields {
    init?(
        boardString: String = "9/9/9/9/9/9/9/9/9",
        colorString: String = "b",
        capturedPiecesString: String = "-"
    ) {
        self.init(string: [boardString, colorString, capturedPiecesString].joined(separator: " "))
    }
}
