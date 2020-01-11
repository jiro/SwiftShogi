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
    public func isAttackable(from sourceSquare: Square, to destinationSquare: Square) -> Bool {
        attacksBitboard(from: sourceSquare)[destinationSquare]
    }

    /// Returns the attackable squares from `square`.
    public func attackableSuqares(from square: Square) -> [Square] {
        attacksBitboard(from: square).squares
    }

    /// Returns the attackable squares to `square` corresponding to `color`.
    public func attackableSquares(to square: Square, for color: Color? = nil) -> [Square] {
        occupiedSquares(for: color).filter { occupiedSquare in
            attacksBitboard(from: occupiedSquare).squares.contains(square)
        }
    }

    /// Returns the occupied squares corresponding to `color`.
    public func occupiedSquares(for color: Color? = nil) -> [Square] {
        let bitboard = occupiedBitboard { piece in
            guard let color = color else { return true }
            return piece.color == color
        }
        return bitboard.squares
    }

    /// Returns the empty squares.
    public var emptySquares: [Square] {
        let bitboard = ~occupiedBitboard()
        return bitboard.squares
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
