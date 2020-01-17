import XCTest
import SwiftShogi

final class GamePerformanceTests: XCTestCase {
    func testValidMoves() {
        let game = Game(sfen: .default)
        measure {
            _ = game.validMoves()
        }
    }
}
