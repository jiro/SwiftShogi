import XCTest
@testable import SwiftShogi

final class SquareTests: XCTestCase {
    func testFile() {
        let square = Square.oneA
        XCTAssertEqual(square.file, File.one)
    }

    func testRank() {
        let square = Square.oneA
        XCTAssertEqual(square.rank, Rank.a)
    }

    func testFileCases() {
        let cases = Square.cases(at: .one)
        XCTAssertEqual(cases, [.oneA, .oneB, .oneC, .oneD, .oneE, .oneF, .oneG, .oneH, .oneI])
    }

    func testRankCases() {
        let cases = Square.cases(at: .a)
        XCTAssertEqual(cases, [.oneA, .twoA, .threeA, .fourA, .fiveA, .sixA, .sevenA, .eightA, .nineA])
    }

    func testPromotableCases() {
        let colors: [(color: Color, expected: [Square])] = [
            (.black, [
                .oneA,   .oneB,   .oneC,
                .twoA,   .twoB,   .twoC,
                .threeA, .threeB, .threeC,
                .fourA,  .fourB,  .fourC,
                .fiveA,  .fiveB,  .fiveC,
                .sixA,   .sixB,   .sixC,
                .sevenA, .sevenB, .sevenC,
                .eightA, .eightB, .eightC,
                .nineA,  .nineB,  .nineC,
            ]),
            (.white, [
                .oneG,   .oneH,   .oneI,
                .twoG,   .twoH,   .twoI,
                .threeG, .threeH, .threeI,
                .fourG,  .fourH,  .fourI,
                .fiveG,  .fiveH,  .fiveI,
                .sixG,   .sixH,   .sixI,
                .sevenG, .sevenH, .sevenI,
                .eightG, .eightH, .eightI,
                .nineG,  .nineH,  .nineI,
            ])
        ]
        colors.forEach {
            XCTAssertEqual(Square.promotableCases(for: $0.color), $0.expected)
        }
    }
}
