#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

// MARK: - IosVersion

public final class IosVersion: Comparable, CustomStringConvertible {
    public typealias VersionComponent = Int
    public let versionComponents: [VersionComponent]
    
    public var majorVersion: VersionComponent {
        return versionComponents.first ?? 0
    }
    
    public var majorAndMinor: String {
        guard versionComponents.count > 2 else {
            return versionComponents.map { String($0) } .joined(separator: ".")
        }
        
        return versionComponents.dropLast().map { String($0) } .joined(separator: ".")
    }
    
    public init(versionComponents: [VersionComponent]) {
        self.versionComponents = versionComponents
    }
    
    public convenience init(major: VersionComponent, minor: VersionComponent? = nil, patch: VersionComponent? = nil) {
        self.init(versionComponents: [major, minor, patch].compactMap { $0 })
    }
    
    public convenience init(versionString: String) throws {
        try self.init(
            versionComponents: versionString
                .components(separatedBy: ".")
                .map {
                    try Int($0).unwrapOrThrow(
                        message: "Version component can not be converted to \(VersionComponent.self). Component: \($0)"
                    )
                }
        )
    }
    
    public var description: String {
        return versionComponents
            .map { String(describing: $0) }
            .joined(separator: ".")
    }
}

// MARK: - Operators (IosVersion)

// [7] == [7, 0]
public func ==(left: IosVersion, right: IosVersion) -> Bool {
    for (a, b) in mb_zip(left.versionComponents, right.versionComponents, pad: 0) {
        // This rule is bugged for the current case
        // swiftlint:disable:next for_where
        if a != b {
            return false
        }
    }
    return true
}

public func >=(left: IosVersion, right: IosVersion) -> Bool {
    for (a, b) in mb_zip(left.versionComponents, right.versionComponents, pad: 0) {
        if a > b {
            return true
        } else if a < b {
            return false
        }
    }
    return true
}

public func >(left: IosVersion, right: IosVersion) -> Bool {
    return left >= right && left != right
}

public func !=(left: IosVersion, right: IosVersion) -> Bool {
    return !(left == right)
}

public func <=(left: IosVersion, right: IosVersion) -> Bool {
    return !(left > right)
}

public func <(left: IosVersion, right: IosVersion) -> Bool {
    return !(left >= right)
}

// MARK: - Operators (Different types)

public func >=(left: Int, right: IosVersion) -> Bool {
    return IosVersion(versionComponents: [left]) >= right
}
public func >=(left: IosVersion, right: Int) -> Bool {
    return left >= IosVersion(versionComponents: [right])
}

public func <=(left: Int, right: IosVersion) -> Bool {
    return IosVersion(versionComponents: [left]) <= right
}
public func <=(left: IosVersion, right: Int) -> Bool {
    return left <= IosVersion(versionComponents: [right])
}

public func >(left: Int, right: IosVersion) -> Bool {
    return IosVersion(versionComponents: [left]) > right
}
public func >(left: IosVersion, right: Int) -> Bool {
    return left > IosVersion(versionComponents: [right])
}

public func <(left: Int, right: IosVersion) -> Bool {
    return IosVersion(versionComponents: [left]) < right
}
public func <(left: IosVersion, right: Int) -> Bool {
    return left < IosVersion(versionComponents: [right])
}

public func ==(left: Int, right: IosVersion) -> Bool {
    return IosVersion(versionComponents: [left]) == right
}
public func ==(left: IosVersion, right: Int) -> Bool {
    return left == IosVersion(versionComponents: [right])
}

public func !=(left: Int, right: IosVersion) -> Bool {
    return IosVersion(versionComponents: [left]) != right
}
public func !=(left: IosVersion, right: Int) -> Bool {
    return left != IosVersion(versionComponents: [right])
}

// MARK: Operators (Switch)

public func ~=(pattern: ClosedRange<Int>, value: IosVersion) -> Bool {
    return pattern.lowerBound <= value && value <= pattern.upperBound
}
public func ~=(pattern: Range<Int>, value: IosVersion) -> Bool {
    return pattern.lowerBound <= value && value < pattern.upperBound
}

public func ~=(pattern: IosVersion, value: IosVersion) -> Bool {
    return pattern == value
}

#endif
