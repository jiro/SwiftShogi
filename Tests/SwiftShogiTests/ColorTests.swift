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
}
