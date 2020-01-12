public enum File: Int, CaseIterable {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
}

public enum Rank: Int, CaseIterable {
    case a
    case b
    case c
    case d
    case e
    case f
    case g
    case h
    case i
}

public enum Square: Int, CaseIterable {
    case oneA,   oneB,   oneC,   oneD,   oneE,   oneF,   oneG,   oneH,   oneI
    case twoA,   twoB,   twoC,   twoD,   twoE,   twoF,   twoG,   twoH,   twoI
    case threeA, threeB, threeC, threeD, threeE, threeF, threeG, threeH, threeI
    case fourA,  fourB,  fourC,  fourD,  fourE,  fourF,  fourG,  fourH,  fourI
    case fiveA,  fiveB,  fiveC,  fiveD,  fiveE,  fiveF,  fiveG,  fiveH,  fiveI
    case sixA,   sixB,   sixC,   sixD,   sixE,   sixF,   sixG,   sixH,   sixI
    case sevenA, sevenB, sevenC, sevenD, sevenE, sevenF, sevenG, sevenH, sevenI
    case eightA, eightB, eightC, eightD, eightE, eightF, eightG, eightH, eightI
    case nineA,  nineB,  nineC,  nineD,  nineE,  nineF,  nineG,  nineH,  nineI
}

extension Square {
    public init(file: File, rank: Rank) {
        self = Self.allCases.first { $0.file == file && $0.rank == rank }!
    }

    public var file: File { File(rawValue: rawValue / File.allCases.count)! }
    public var rank: Rank { Rank(rawValue: rawValue % Rank.allCases.count)! }

    public static func cases(at file: File) -> [Self] { allCases.filter { $0.file == file } }
    public static func cases(at rank: Rank) -> [Self] { allCases.filter { $0.rank == rank } }

    public static func promotableCases(for color: Color) -> [Self] {
        let ranks: [Rank] = color.isBlack ? [.a, .b, .c] : [.g, .h, .i]
        return allCases.filter { ranks.contains($0.rank) }
    }
}
