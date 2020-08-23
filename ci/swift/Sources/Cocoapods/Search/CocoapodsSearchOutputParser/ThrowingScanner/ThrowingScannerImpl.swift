import Foundation
import CiFoundation

public final class ThrowingScannerImpl: ThrowingScanner {
    private let scanner: Scanner
    
    public init(string: String) {
        self.scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
    }
    
    public var isAtEnd: Bool {
        return scanner.isAtEnd
    }
    
    public func scanToEnd() throws -> String {
        if isAtEnd {
            throw ErrorString("Already at end")
        }
        
        let result = remainingString()
        
        scanner.scanLocation = (scanner.string as NSString).length
        
        return result
    }
    
    public func remainingString() -> String {
        return remainingString(scanLocation: scanner.scanLocation)
    }
    
    public func scan(
        mode: ThrowingScannerScanningMode,
        option: ThrowingScannerScanningOption)
        throws
        -> String
    {
        switch mode {
        case .scanPass:
            return try scanPass(option: option)
        case .scanUntil:
            return try scanUntil(option: option)
        case .scanWhile:
            return try scanWhile(option: option)
        }
    }
    
    private func scanPass(
        option: ThrowingScannerScanningOption)
        throws
        -> String
    {
        let result: String
        
        let scanLocation = scanner.scanLocation
        
        do {
            result = try scanUntil(option: option)
        } catch {
            // It can be already scanned until and NSScanner fails in this case.
            result = ""
        }
        
        do {
            _ = try scanWhile(option: option)
        } catch {
            scanner.scanLocation = scanLocation
            throw error
        }
        
        return result
    }
    
    private func scanWhile(
        option: ThrowingScannerScanningOption)
        throws
        -> String
    {
        return try scan(
            scanningFunction: option.scanWhile,
            scanningModeString: "while",
            subjectDescription: option.subjectDescription
        )
    }
    
    private func scanUntil(
        option: ThrowingScannerScanningOption)
        throws
        -> String
    {
        return try scan(
            scanningFunction: option.scanUntil,
            scanningModeString: "until",
            subjectDescription: option.subjectDescription
        )
    }
    
    private func scan(
        scanningFunction: (Scanner, inout NSString?) -> Bool,
        scanningModeString: String,
        subjectDescription: () -> String)
        throws
        -> String
    {
        var nsString: NSString?
        
        let scanLocation = scanner.scanLocation
        
        if !scanningFunction(scanner, &nsString) {
            scanner.scanLocation = scanLocation
            
            throw ErrorString(
                """
                Failed to scan \(scanningModeString) \(subjectDescription()) in "\(remainingString())"
                """
            )
        }
        
        guard let scannedString = nsString as String? else {
            scanner.scanLocation = scanLocation
            
            throw ErrorString(
                """
                Failed to scan \(scanningModeString) \(subjectDescription()) (scanned string is nil) in "\(remainingString())"
                """
            )
        }
        
        return scannedString
    }
    
    private func remainingString(scanLocation: Int) -> String {
        // `scanLocation` is probably works correctly for NSString only (I am not sure, because
        // I didn't test it; for example, for diacritics and other edge-case things)
        return (scanner.string as NSString).substring(from: scanLocation) as String
    }
}
