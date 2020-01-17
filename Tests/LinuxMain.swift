import XCTest

import PerformanceTests
import SwiftShogiTests

var tests = [XCTestCaseEntry]()
tests += PerformanceTests.__allTests()
tests += SwiftShogiTests.__allTests()

XCTMain(tests)
