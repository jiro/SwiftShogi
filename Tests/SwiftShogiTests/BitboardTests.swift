import XCTest
@testable import SwiftShogi

final class BitboardTests: XCTestCase {
    func testSubscript() {
        var bitboard = Bitboard(rawValue: 0)
        XCTAssertFalse(bitboard[.oneA])

        bitboard[.oneA] = true
        XCTAssertTrue(bitboard[.oneA])

        bitboard[.oneA] = false
        XCTAssertFalse(bitboard[.oneA])
    }
}
