struct UInt128 {
    private(set) var upperBits: UInt64
    private(set) var lowerBits: UInt64

    prefix static func ~ (x: Self) -> Self {
        Self(
            upperBits: ~x.upperBits,
            lowerBits: ~x.lowerBits
        )
    }

    static func & (lhs: Self, rhs: Self) -> Self {
        Self(
            upperBits: lhs.upperBits & rhs.upperBits,
            lowerBits: lhs.lowerBits & rhs.lowerBits
        )
    }

    static func &= (lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }

    static func | (lhs: Self, rhs: Self) -> Self {
        Self(
            upperBits: lhs.upperBits | rhs.upperBits,
            lowerBits: lhs.lowerBits | rhs.lowerBits
        )
    }

    static func |= (lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }

    static func << (lhs: Self, rhs: Int) -> Self {
        let shift = rhs
        if shift < 0 { return lhs >> abs(shift) }

        return Self(
            upperBits: lhs.upperBits << shift | lhs.lowerBits << (shift - UInt64.bitWidth),
            lowerBits: lhs.lowerBits << shift
        )
    }

    static func >> (lhs: Self, rhs: Int) -> Self {
        let shift = rhs
        if shift < 0 { return lhs << abs(shift) }

        return Self(
            upperBits: lhs.upperBits >> shift,
            lowerBits: lhs.lowerBits >> shift | lhs.upperBits >> (shift - UInt64.bitWidth)
        )
    }
}

extension UInt128: ExpressibleByIntegerLiteral {
    init(integerLiteral value: UInt64) {
        self.init(value)
    }

    init<T>(_ source: T) where T : BinaryInteger {
        self.init(upperBits: 0, lowerBits: UInt64(source))
    }
}

extension UInt128: Equatable {}
