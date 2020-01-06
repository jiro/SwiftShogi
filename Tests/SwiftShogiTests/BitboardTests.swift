import XCTest
@testable import SwiftShogi

final class BitboardTests: XCTestCase {
    func testSquares() {
        let bitboard = Bitboard(bits: [
            1, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 1,
        ])
        XCTAssertEqual(bitboard.squares, [.oneA, .nineI])
    }

    func testSubscript() {
        var bitboard = Bitboard(rawValue: 0)
        XCTAssertFalse(bitboard[.oneA])

        bitboard[.oneA] = true
        XCTAssertTrue(bitboard[.oneA])

        bitboard[.oneA] = false
        XCTAssertFalse(bitboard[.oneA])
    }

    func testAttacks() {
        let piece = Piece(kind: .rook(.promoted), color: .black)
        let square = Square.fiveE
        let stoppers = Bitboard(rawValue: 0)
        let attacks = Bitboard.attacks(for: piece, at: square, stoppers: stoppers)

        let expected = Bitboard(bits: [
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 1, 1, 1, 0, 0, 0,
            1, 1, 1, 1, 0, 1, 1, 1, 1,
            0, 0, 0, 1, 1, 1, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0, 0, 0,
        ])
        XCTAssertEqual(attacks, expected)
    }

    func testAttacksWithStoppers() {
        let piece = Piece(kind: .rook(.promoted), color: .black)
        let square = Square.fiveE
        let stoppers = Bitboard(bits: [
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 1, 1, 0, 0, 1, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
        ])
        let attacks = Bitboard.attacks(for: piece, at: square, stoppers: stoppers)

        let expected = Bitboard(bits: [
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 1, 1, 1, 0, 0, 0,
            0, 0, 0, 1, 0, 1, 1, 1, 0,
            0, 0, 0, 1, 1, 1, 0, 0, 0,
            0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
        ])
        XCTAssertEqual(attacks, expected)
    }
}

private extension Bitboard {
    init(bits: [UInt8]) {
        var bitboard = Bitboard(rawValue: 0)
        zip(Square.allCases, bits)
            .map { ($0.0, $0.1 > 0) }
            .forEach { square, hasBit in bitboard[square] = hasBit }
        self = bitboard
    }
}
