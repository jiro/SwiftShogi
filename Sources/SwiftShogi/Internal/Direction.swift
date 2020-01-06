 enum Direction: CaseIterable {
    case north
    case south
    case east
    case west
    case northEast
    case northWest
    case southEast
    case southWest
    case northNorthEast
    case northNorthWest
    case southSouthEast
    case southSouthWest
}

extension Direction {
    var flippedVertically: Self {
        let flippedComponents: [Component] = components.map {
            switch $0 {
            case .north: return .south
            case .south: return .north
            default: return $0
            }
        }
        return Self.allCases.first { $0.components == flippedComponents }!
    }

    var containsNorth: Bool { components.contains(.north) }
    var containsSouth: Bool { components.contains(.south) }

    var shift: Int {
        components.map({ $0.shift }).reduce(0, +)
    }

    private enum Component {
        case north
        case south
        case east
        case west

        var shift: Int {
            switch self {
            case .north: return -1
            case .south: return 1
            case .east: return -File.allCases.count
            case .west: return File.allCases.count
            }
        }
    }

    private var components: [Component] {
        switch self {
        case .north: return [.north]
        case .south: return [.south]
        case .east: return [.east]
        case .west: return [.west]
        case .northEast: return [.north, .east]
        case .northWest: return [.north, .west]
        case .southEast: return [.south, .east]
        case .southWest: return [.south, .west]
        case .northNorthEast: return [.north, .north, .east]
        case .northNorthWest: return [.north, .north, .west]
        case .southSouthEast: return [.south, .south, .east]
        case .southSouthWest: return [.south, .south, .west]
        }
    }
}
