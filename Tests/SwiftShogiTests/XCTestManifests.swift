import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BitboardTests.allTests),
        testCase(ColorTests.allTests),
        testCase(PieceTests.allTests),
        testCase(SquareTests.allTests),
        testCase(UInt128Tests.allTests),
    ]
}
#endif
