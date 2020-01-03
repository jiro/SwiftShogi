struct UInt128 {
    var upperBits: UInt64
    var lowerBits: UInt64
}

extension UInt128: ExpressibleByIntegerLiteral {
    init(integerLiteral value: UInt64) {
        self.init(value)
    }

    init<T>(_ source: T) where T : BinaryInteger {
        self.init(upperBits: 0, lowerBits: UInt64(source))
    }
}
