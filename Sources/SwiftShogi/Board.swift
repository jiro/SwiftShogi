/// A shogi board used to map `Square`s to `Piece`s.
public struct Board: Equatable {
    private var pieceBitboards: [Piece: Bitboard]

    /// Creates a shogi board.
    public init() {
        let piecesAndBitboards = Piece.allCases.map { ($0, Bitboard(rawValue: 0)) }
        pieceBitboards = Dictionary(uniqueKeysWithValues: piecesAndBitboards)
    }
}

extension Board {
    /// Gets and sets a piece at `square`.
    public subscript(square: Square) -> Piece? {
        get {
            pieceBitboards.keys.first { exists($0, at: square) }
        }
        set(piece) {
            pieceBitboards.keys.forEach { remove($0, from: square) }
            if let piece = piece {
                insert(piece, to: square)
            }
        }
    }

    /// Returns `true` if a piece can attack from the source square to the destination square.
    public func isAttackable(from sourceSquare: Square, to destinationSquare: Square) -> Bool {
        attacksBitboard(from: sourceSquare)[destinationSquare]
    }

    /// Returns the attackable squares from `square`.
    public func attackableSuqares(from square: Square) -> [Square] {
        attacksBitboard(from: square).squares
    }

    /// Returns the attackable squares to `square` corresponding to `color`.
    public func attackableSquares(to destinationSquare: Square, for color: Color? = nil) -> [Square] {
        occupiedSquares(for: color).filter { sourceSquare in
            isAttackable(from: sourceSquare, to: destinationSquare)
        }
    }

    /// Returns the occupied squares corresponding to `color`.
    public func occupiedSquares(for color: Color? = nil) -> [Square] {
        occupiedBitboard(for: color).squares
    }

    /// Returns the empty squares.
    public var emptySquares: [Square] {
        (~occupiedBitboard()).squares
    }

    /// Returns `true` if the king for `color` is in check.
    public func isKingChecked(for color: Color) -> Bool {
        let piece = Piece(kind: .king, color: color)
        guard let square = pieceBitboards[piece]!.squares.first else { return false }
        return !attackableSquares(to: square, for: color.toggled()).isEmpty
    }

    /// Returns `true` if the king for `color` is in check by moving a piece.
    public func isKingCheckedByMovingPiece(from sourceSquare: Square, to destinationSquare: Square, for color: Color) -> Bool {
        var board = self
        board.movePiece(from: sourceSquare, to: destinationSquare)
        return board.isKingChecked(for: color)
    }

    /// Returns `true` if the king for `color` is in check by moving `piece`.
    public func isKingCheckedByMovingPiece(_ piece: Piece, to destinationSquare: Square, for color: Color) -> Bool {
        var board = self
        board.movePiece(piece, to: destinationSquare)
        return board.isKingChecked(for: color)
    }
}

private extension Board {
    func exists(_ piece: Piece, at square: Square) -> Bool {
        pieceBitboards[piece]![square]
    }

    mutating func insert(_ piece: Piece, to square: Square) {
        pieceBitboards[piece]![square] = true
    }

    mutating func remove(_ piece: Piece, from square: Square) {
        pieceBitboards[piece]![square] = false
    }

    mutating func movePiece(from sourceSquare: Square, to destinationSquare: Square) {
        movePiece(self[sourceSquare], to: destinationSquare)
        self[sourceSquare] = nil
    }

    mutating func movePiece(_ piece: Piece?, to destinationSquare: Square) {
        self[destinationSquare] = piece
    }

    func attacksBitboard(from square: Square) -> Bitboard {
        guard let piece = self[square] else { return Bitboard(rawValue: 0) }
        return Bitboard.attacks(from: square, piece: piece, stoppers: occupiedBitboard())
    }

    func occupiedBitboard(for color: Color? = nil) -> Bitboard {
        var pieceBitboards = self.pieceBitboards
        if let color = color {
            pieceBitboards = pieceBitboards.filter { piece, _ in piece.color == color }
        }
        return pieceBitboards.values.reduce(Bitboard(rawValue: 0), |)
    }
}
