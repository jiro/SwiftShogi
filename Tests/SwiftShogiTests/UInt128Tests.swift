import XCTest
@testable import SwiftShogi

final class UInt128Tests: XCTestCase {
    func testLeftShift() {
        let a: UInt64 = 0xffffffffffffffff
        let b: UInt64 = 0xfffffffffffffffe
        let c: UInt64 = 0x7fffffffffffffff

        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) << 0, UInt128(upperBits: a, lowerBits: a))

        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) << 1, UInt128(upperBits: a, lowerBits: b))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) << 64, UInt128(upperBits: a, lowerBits: 0))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) << 65, UInt128(upperBits: b, lowerBits: 0))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) << 128, UInt128(upperBits: 0, lowerBits: 0))

        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) << -1, UInt128(upperBits: c, lowerBits: a))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) << -64, UInt128(upperBits: 0, lowerBits: a))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) << -65, UInt128(upperBits: 0, lowerBits: c))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) << -128, UInt128(upperBits: 0, lowerBits: 0))
    }

    func testRightShift() {
        let a: UInt64 = 0xffffffffffffffff
        let b: UInt64 = 0xfffffffffffffffe
        let c: UInt64 = 0x7fffffffffffffff

        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) >> 0, UInt128(upperBits: a, lowerBits: a))

        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) >> 1, UInt128(upperBits: c, lowerBits: a))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) >> 64, UInt128(upperBits: 0, lowerBits: a))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) >> 65, UInt128(upperBits: 0, lowerBits: c))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) >> 128, UInt128(upperBits: 0, lowerBits: 0))

        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) >> -1, UInt128(upperBits: a, lowerBits: b))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) >> -64, UInt128(upperBits: a, lowerBits: 0))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) >> -65, UInt128(upperBits: b, lowerBits: 0))
        XCTAssertEqual(UInt128(upperBits: a, lowerBits: a) >> -128, UInt128(upperBits: 0, lowerBits: 0))
    }
}
