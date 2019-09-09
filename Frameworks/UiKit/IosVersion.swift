#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

// MARK: - IosVersion

public struct IosVersion: Comparable {
    fileprivate let version: [Int]
    
    public var majorVersion: Int {
        return version.first ?? 0
    }
    
    public var majorAndMinor: String {
        guard version.count > 2 else {
            return version.map { String($0) } .joined(separator: ".")
        }
        
        return version.dropLast().map { String($0) } .joined(separator: ".")
    }
    
    public init(_ versionString: String) {
        version = versionString.components(separatedBy: ".").compactMap { $0.mb_toInt() }
    }
}

// MARK: - UIDevice+IosVersion

// Examples:
//
// if UIDevice.iosVersion.majorVersion <= 7 { // iOS 6, iOS 7, iOS 7.1 suits
//
// switch UIDevice.iosVersion {
// case 6: break // iOS 6 suits
// case 7..<9: break // iOS 7, iOS 8, iOS 8.1 suits
// case 9...10: break // iOS 9, iOS 10 suits
// default: break
// }
extension UIDevice {
    public var mb_iosVersion: IosVersion {
        return IosVersion(systemVersion)
    }
}

// MARK: - Operators (IosVersion)

// [7] == [7, 0]
public func ==(left: IosVersion, right: IosVersion) -> Bool {
    for (a, b) in mb_zip(left.version, right.version, pad: 0) {
        // This rule is bugged for the current case
        // swiftlint:disable:next for_where
        if a != b {
            return false
        }
    }
    return true
}

public func >=(left: IosVersion, right: IosVersion) -> Bool {
    for (a, b) in mb_zip(left.version, right.version, pad: 0) {
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

public func >= <T>(left: T, right: IosVersion) -> Bool {
    return IosVersion(String(describing: left)) >= right
}
public func >= <T>(left: IosVersion, right: T) -> Bool {
    return left >= IosVersion(String(describing: right))
}

public func <= <T>(left: T, right: IosVersion) -> Bool {
    return IosVersion(String(describing: left)) <= right
}
public func <= <T>(left: IosVersion, right: T) -> Bool {
    return left <= IosVersion(String(describing: right))
}

public func > <T>(left: T, right: IosVersion) -> Bool {
    return IosVersion(String(describing: left)) > right
}
public func > <T>(left: IosVersion, right: T) -> Bool {
    return left > IosVersion(String(describing: right))
}

public func < <T>(left: T, right: IosVersion) -> Bool {
    return IosVersion(String(describing: left)) < right
}
public func < <T>(left: IosVersion, right: T) -> Bool {
    return left < IosVersion(String(describing: right))
}

public func == <T>(left: T, right: IosVersion) -> Bool {
    return IosVersion(String(describing: left)) == right
}
public func == <T>(left: IosVersion, right: T) -> Bool {
    return left == IosVersion(String(describing: right))
}

public func != <T>(left: T, right: IosVersion) -> Bool {
    return IosVersion(String(describing: left)) != right
}
public func != <T>(left: IosVersion, right: T) -> Bool {
    return left != IosVersion(String(describing: right))
}

// MARK: Operators (Switch)

public func ~= <T>(pattern: ClosedRange<T>, value: IosVersion) -> Bool {
    return pattern.lowerBound <= value && value <= pattern.upperBound
}
public func ~= <T>(pattern: Range<T>, value: IosVersion) -> Bool {
    return pattern.lowerBound <= value && value < pattern.upperBound
}

public func ~=(pattern: IosVersion, value: IosVersion) -> Bool {
    return pattern == value
}

#endif
