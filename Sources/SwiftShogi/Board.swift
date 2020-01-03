public struct Board {
    private(set) var pieceBitboards: [Piece: Bitboard]

    public init() {
        pieceBitboards = Dictionary(uniqueKeysWithValues: Piece.allCases.map { ($0, Bitboard(rawValue: 0)) })
    }
}
