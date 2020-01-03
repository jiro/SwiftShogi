struct Bitboard: RawRepresentable {
    private(set) var rawValue: UInt128

    init(rawValue: UInt128) {
        self.rawValue = rawValue
    }
}
