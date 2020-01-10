/// A shogi board used to map `Square`s to `Piece`s.
public struct Board {
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
            allPieces.first { exists($0, at: square) }
        }
        set(piece) {
            allPieces.forEach { remove($0, from: square) }
            if let piece = piece {
                insert(piece, to: square)
            }
        }
    }

    /// Returns `true` if a piece can attack from the source square to the destination square.
    public func isValidAttack(from sourceSquare: Square, to destinationSquare: Square) -> Bool {
        attacksBitboard(from: sourceSquare)[destinationSquare]
    }

    /// Returns the attackable squares from `square`.
    public func attackableSuqares(from square: Square) -> [Square] {
        attacksBitboard(from: square).squares
    }

    /// Returns the occupied squares for `color`.
    public func occupiedSquares(for color: Color) -> [Square] {
        occupiedBitboard(where: { piece in piece.color == color }).squares
    }

    /// Returns the empty squares.
    public var emptySquares: [Square] {
        (~occupiedBitboard()).squares
    }
}

private extension Board {
    var allPieces: [Piece] { Array(pieceBitboards.keys) }

    func exists(_ piece: Piece, at square: Square) -> Bool {
        pieceBitboards[piece]![square]
    }

    mutating func insert(_ piece: Piece, to square: Square) {
        pieceBitboards[piece]![square] = true
    }

    mutating func remove(_ piece: Piece, from square: Square) {
        pieceBitboards[piece]![square] = false
    }

    func attacksBitboard(from square: Square) -> Bitboard {
        guard let piece = self[square] else { return Bitboard(rawValue: 0) }
        return Bitboard.attacks(from: square, piece: piece, stoppers: occupiedBitboard())
    }

    func occupiedBitboard(where predicate: ((Piece) -> Bool)? = nil) -> Bitboard {
        pieceBitboards
            .filter { piece, _ in
                guard let predicate = predicate else { return true }
                return predicate(piece)
            }
            .values
            .reduce(Bitboard(rawValue: 0), |)
    }
}
