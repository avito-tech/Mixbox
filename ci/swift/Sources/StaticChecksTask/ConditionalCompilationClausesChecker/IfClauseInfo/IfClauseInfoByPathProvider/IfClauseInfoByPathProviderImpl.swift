import Foundation

public final class IfClauseInfoByPathProviderImpl: IfClauseInfoByPathProvider {
    public init() {
    }
    
    public func ifClauseInfo(path: String) -> IfClauseInfo? {
        let flagName = "MIXBOX_ENABLE_IN_APP_SERVICES"

        let lastPathComponent = (path as NSString).lastPathComponent
        
        if exceptions.contains(lastPathComponent) {
            return nil
        } else {
            switch (path as NSString).pathExtension.lowercased() {
            case "swift":
                return IfClauseInfo(
                    clauseOpening: "#if \(flagName)",
                    clauseClosing: "#endif"
                )
            case "h", "m", "mm", "c", "cxx", "cpp", "c++", "cc", "hh", "hm", "hpp", "hxx":
                return IfClauseInfo(
                    clauseOpening: "#ifdef \(flagName)",
                    clauseClosing: "#endif"
                )
            default:
                return nil
            }
        }
    }
    
    private let exceptions: [String] = [
        "EnsureReleaseAppIsNotAffected.swift",
        "TestabilityElement.h",
        "TestabilityElementType.h",
        "NSObject+AccessibilityPlaceholderValue.h"
    ]
}
