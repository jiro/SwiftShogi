import XCTest
@testable import SwiftShogi

final class ColorTests: XCTestCase {
    func testToggle() {
        var color = Color.black

        color.toggle()
        XCTAssertEqual(color, .white)

        color.toggle()
        XCTAssertEqual(color, .black)
    }

    func testInitializerWithCharacter() {
        let characters: [(character: Character, expected: Color?)] = [
            (Character("b"), .black),
            (Character("w"), .white),
            (Character("z"), nil),
        ]
        characters.forEach {
            XCTAssertEqual(Color(character: $0.character), $0.expected)
        }
    }
}
