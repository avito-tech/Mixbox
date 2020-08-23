import Foundation
import CiFoundation

public enum ThrowingScannerScanningMode {
    case scanWhile
    case scanUntil
    case scanPass
}

public struct ThrowingScannerScanningOption {
    let scanWhile: (Scanner, inout NSString?) -> Bool
    let scanUntil: (Scanner, inout NSString?) -> Bool
    let subjectDescription: () -> String
}

// Wrapper for scanner with better error handling.
//
//  scanWhile - consumes remaining string while string matches and returnes consumed string
//
//      string:    "x.y.z"
//      call:      scanWhile("x")
//      result:    "x"
//      remainder: ".y.z"
//
//  scanUntil - consumes remaining string until string matches and returnes consumed string
//
//      string:    "x.y.z"
//      call:      scanUntil("y")
//      result:    "x."
//      remainder: "y.z"
//
//  scanPass - consumes remaining string until string matches and returnes consumed string,
//             then consumes sting while it matches. In short it is scanUntil + scanWhile
//
//      string:    "x.y.z"
//      call:      scanPass("y")
//      result:    "x."
//      remainder: ".z"
//
public protocol ThrowingScanner {
    var isAtEnd: Bool { get }
    func scanToEnd() throws -> String
    func remainingString() -> String
    
    func scan(
        mode: ThrowingScannerScanningMode,
        option: ThrowingScannerScanningOption)
        throws
        -> String
}

extension ThrowingScanner {
    public func scanningOption(string: String) -> ThrowingScannerScanningOption {
        ThrowingScannerScanningOption(
            scanWhile: { scanner, nsString in
                scanner.scanString(string, into: &nsString)
            },
            scanUntil: { scanner, nsString in
                scanner.scanUpTo(string, into: &nsString)
            },
            subjectDescription: {
                "\"\(string)\""
            }
        )
    }
    
    public func scanningOption(characterSet: CharacterSet) -> ThrowingScannerScanningOption {
        ThrowingScannerScanningOption(
            scanWhile: { scanner, nsString in
                scanner.scanCharacters(from: characterSet, into: &nsString)
            },
            scanUntil: { scanner, nsString in
                scanner.scanUpToCharacters(from: characterSet, into: &nsString)
            },
            subjectDescription: {
                "\(characterSet)"
            }
        )
    }
    
    @discardableResult
    public func scanWhile(_ string: String) throws -> String {
        return try scan(
            mode: .scanWhile,
            option: scanningOption(string: string)
        )
    }
    
    @discardableResult
    public func scanWhile(_ characterSet: CharacterSet) throws -> String {
        return try scan(
            mode: .scanWhile,
            option: scanningOption(characterSet: characterSet)
        )
    }
    
    @discardableResult
    public func scanPass(_ string: String) throws -> String {
        return try scan(
            mode: .scanPass,
            option: scanningOption(string: string)
        )
    }
    
    @discardableResult
    public func scanPass(_ characterSet: CharacterSet) throws -> String {
        return try scan(
            mode: .scanPass,
            option: scanningOption(characterSet: characterSet)
        )
    }
    
    @discardableResult
    public func scanUntil(_ string: String) throws -> String {
        return try scan(
            mode: .scanUntil,
            option: scanningOption(string: string)
        )
    }
    
    @discardableResult
    public func scanUntil(_ characterSet: CharacterSet) throws -> String {
        return try scan(
            mode: .scanUntil,
            option: scanningOption(characterSet: characterSet)
        )
    }
}
