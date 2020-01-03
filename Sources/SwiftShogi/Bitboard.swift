/// A bitmap of eighty-one bits suitable for storing squares for various pieces.
///
/// The first bit refers to `Square.oneA`, and the last (81th) bit refers to `Square.nineI`.
struct Bitboard: RawRepresentable {
    private(set) var rawValue: UInt128

    init(rawValue: UInt128) {
        self.rawValue = rawValue
    }
}

extension Bitboard {

    /// The `Bool` value for the bit at `square`.
    subscript(square: Square) -> Bool {
        get {
            intersects(Self(square: square))
        }
        set(hasBit) {
            if hasBit {
                rawValue |= Self(square: square).rawValue
            } else {
                rawValue &= ~Self(square: square).rawValue
            }
        }
    }

    private init(square: Square) {
        self.init(rawValue: 1 << square.rawValue)
    }

    private func intersects(_ other: Self) -> Bool {
        rawValue & other.rawValue != 0
    }
}
