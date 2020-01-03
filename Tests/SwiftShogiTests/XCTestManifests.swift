import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BitboardTests.allTests),
        testCase(BoardTests.allTests),
        testCase(ColorTests.allTests),
        testCase(GameTests.allTests),
        testCase(PieceTests.allTests),
        testCase(SquareTests.allTests),
        testCase(UInt128Tests.allTests),
    ]
}
#endif
