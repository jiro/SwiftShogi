import XCTest
@testable import SwiftShogi

final class DirectionTests: XCTestCase {
    func testFlippedHorizontally() {
        let directions: [(direction: Direction, expected: Direction)] = [
            (.north, .south),
            (.south, .north),
            (.east, .east),
            (.west, .west),
            (.northEast, .southEast),
            (.northWest, .southWest),
            (.southEast, .northEast),
            (.southWest, .northWest),
            (.northNorthEast, .southSouthEast),
            (.northNorthWest, .southSouthWest),
            (.southSouthEast, .northNorthEast),
            (.southSouthWest, .northNorthWest),
        ]
        directions.forEach { XCTAssertEqual($0.direction.flippedVertically, $0.expected)
        }
    }

    func testShift() {
        let directions: [(direction: Direction, expected: Int)] = [
            (.north, -1),
            (.south, 1),
            (.east, -9),
            (.west, 9),
            (.northEast, -10),
            (.northWest, 8),
            (.southEast, -8),
            (.southWest, 10),
            (.northNorthEast, -11),
            (.northNorthWest, 7),
            (.southSouthEast, -7),
            (.southSouthWest, 11),
        ]
        directions.forEach {
            XCTAssertEqual($0.direction.shift, $0.expected)
        }
    }
}
