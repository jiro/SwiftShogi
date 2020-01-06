import XCTest
@testable import SwiftShogi

final class GameTests: XCTestCase {
    func testPerformFromBoard() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.oneA: piece])
        var game = Game(board: board)
        XCTAssertEqual(game.board[.oneA], piece)
        XCTAssertNil(game.board[.oneB])
        XCTAssertEqual(game.color, .black)
        XCTAssertTrue(game.capturedPieces.isEmpty)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece
        )
        XCTAssertNoThrow(try game.perform(move))

        XCTAssertNil(game.board[.oneA])
        XCTAssertEqual(game.board[.oneB], piece)
        XCTAssertEqual(game.color, .white)
        XCTAssertTrue(game.capturedPieces.isEmpty)
    }

    func testPerformFromCapturedPiece() {
        let piece = Piece(kind: .gold, color: .black)
        var game = Game(capturedPieces: [piece])
        XCTAssertNil(game.board[.oneA])
        XCTAssertEqual(game.color, .black)
        XCTAssertTrue(game.capturedPieces.contains(piece))

        let move = Move(
            source: .capturedPiece,
            destination: .board(.oneA),
            piece: piece
        )
        XCTAssertNoThrow(try game.perform(move))

        XCTAssertEqual(game.board[.oneA], piece)
        XCTAssertEqual(game.color, .white)
        XCTAssertTrue(game.capturedPieces.isEmpty)
    }

    func testPerformWithCapturingPiece() {
        let piece1 = Piece(kind: .gold, color: .black)
        let piece2 = Piece(kind: .rook(.promoted), color: .white)
        let piece3 = Piece(kind: .pawn(.normal), color: .black)
        let piece4 = Piece(kind: .gold, color: .white)
        let board = Board(pieces: [.oneA: piece1, .oneB: piece2])
        var game = Game(board: board, capturedPieces: [piece3, piece4])
        XCTAssertEqual(game.board[.oneA], piece1)
        XCTAssertEqual(game.board[.oneB], piece2)
        XCTAssertEqual(game.color, .black)
        XCTAssertEqual(game.capturedPieces, [piece3, piece4])

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece1
        )
        XCTAssertNoThrow(try game.perform(move))

        let expected = Piece(kind: .rook(.normal), color: .black)
        XCTAssertNil(game.board[.nineA])
        XCTAssertEqual(game.board[.oneB], piece1)
        XCTAssertEqual(game.color, .white)
        XCTAssertEqual(game.capturedPieces, [expected, piece3, piece4])
    }


    func testValidateWithBoardPieceDoesNotExistMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [:])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .boardPieceDoesNotExist)
        }
    }

    func testValidateWithCapturedPieceDoesNotExistMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let game = Game(capturedPieces: [])

        let move = Move(
            source: .capturedPiece,
            destination: .board(.oneA),
            piece: piece
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .capturedPieceDoesNotExist)
        }
    }

    func testValidateWithInvalidPieceColorMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.oneA: piece])
        let game = Game(board: board, color: .white)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .invalidPieceColor)
        }
    }

    func testValidateWithFriendlyPieceAlreadyExistsMoveValidationError() {
        let piece1 = Piece(kind: .gold, color: .black)
        let piece2 = Piece(kind: .king, color: .black)
        let board = Board(pieces: [.oneA: piece1, .oneB: piece2])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece1
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .friendlyPieceAlreadyExists)
        }
    }

    func testValidateWithIllegalAttackMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.oneA: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneI),
            piece: piece
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .illegalAttack)
        }
    }

    func testValidateWithPieceAlreadyPromotedMoveValidationError() {
        let piece = Piece(kind: .rook(.promoted), color: .black)
        let board = Board(pieces: [.oneA: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece,
            shouldPromote: true
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .pieceAlreadyPromoted)
        }
    }

    func testValidateWithPieceCannotPromoteMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.oneA: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneA),
            destination: .board(.oneB),
            piece: piece,
            shouldPromote: true
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .pieceCannotPromote)
        }
    }

    func testValidateWithIllegalBoardPiecePromotionMoveValidationError() {
        let piece = Piece(kind: .rook(.normal), color: .black)
        let board = Board(pieces: [.oneI: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.oneI),
            destination: .board(.oneH),
            piece: piece,
            shouldPromote: true
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .illegalBoardPiecePromotion)
        }
    }

    func testValidateWithIllegalCapturedPiecePromotionMoveValidationError() {
        let piece = Piece(kind: .rook(.normal), color: .black)
        let game = Game(capturedPieces: [piece])

        let move = Move(
            source: .capturedPiece,
            destination: .board(.oneA),
            piece: piece,
            shouldPromote: true
        )
        XCTAssertThrowsError(try game.validate(move)) { error in
            XCTAssertEqual(error as! Game.MoveValidationError, .illegalCapturedPiecePromotion)
        }
    }

    func testValidMoves() {
        let piece1 = Piece(kind: .silver(.normal), color: .black)
        let piece2 = Piece(kind: .silver(.normal), color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        let piece4 = Piece(kind: .gold, color: .white)
        let board = Board(pieces: [.fiveI: piece1, .fiveA: piece2])
        let game = Game(board: board, capturedPieces: [piece3, piece4])

        let expectedFromBoard: [Move] = [
            .fourH, .fiveH, .sixH
        ].map {
            Move(
                source: .board(.fiveI),
                destination: .board($0),
                piece: piece1,
                shouldPromote: false
            )
        }
        let expectedFromCapturedPiece: [Move] = [
            .oneA,   .oneB,   .oneC,   .oneD,   .oneE,   .oneF,   .oneG,   .oneH,   .oneI,
            .twoA,   .twoB,   .twoC,   .twoD,   .twoE,   .twoF,   .twoG,   .twoH,   .twoI,
            .threeA, .threeB, .threeC, .threeD, .threeE, .threeF, .threeG, .threeH, .threeI,
            .fourA,  .fourB,  .fourC,  .fourD,  .fourE,  .fourF,  .fourG,  .fourH,  .fourI,
            .fiveB,  .fiveC,  .fiveD,  .fiveE,  .fiveF,  .fiveG,  .fiveH,
            .sixA,   .sixB,   .sixC,   .sixD,   .sixE,   .sixF,   .sixG,   .sixH,   .sixI,
            .sevenA, .sevenB, .sevenC, .sevenD, .sevenE, .sevenF, .sevenG, .sevenH, .sevenI,
            .eightA, .eightB, .eightC, .eightD, .eightE, .eightF, .eightG, .eightH, .eightI,
            .nineA,  .nineB,  .nineC,  .nineD,  .nineE,  .nineF,  .nineG,  .nineH,  .nineI,
        ].map {
            Move(
                source: .capturedPiece,
                destination: .board($0),
                piece: piece3,
                shouldPromote: false
            )
        }
        XCTAssertEqual(game.validMoves(), expectedFromBoard + expectedFromCapturedPiece)
    }

    func testValidMovesWithMoveSource() {
        let piece1 = Piece(kind: .silver(.normal), color: .black)
        let piece2 = Piece(kind: .silver(.normal), color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        let piece4 = Piece(kind: .gold, color: .white)
        let board = Board(pieces: [.fiveI: piece1, .fiveA: piece2])
        let game = Game(board: board, capturedPieces: [piece3, piece4])

        let expected: [Move] = [
            .fourH, .fiveH, .sixH
        ].map {
            Move(
                source: .board(.fiveI),
                destination: .board($0),
                piece: piece1,
                shouldPromote: false
            )
        }
        XCTAssertEqual(game.validMoves(from: .board(.fiveI)), expected)
    }
}

private extension Board {
    init(pieces: [Square: Piece]) {
        self.init()
        pieces.forEach { square, piece in self[square] = piece }
    }
}
