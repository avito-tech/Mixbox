import Foundation

// How it works:
//
// MIXBOX_ENABLE_ALL_FRAMEWORKS enables code all frameworks (may be overriden by disabling certain frameworks)
// MIXBOX_DISABLE_FRAMEWORK_NAME_FRAMEWORK disables code in framework `FrameworkName`
// MIXBOX_ENABLE_FRAMEWORK_NAME_FRAMEWORK enables code in framework `FrameworkName`
// If both of the last two are present, raise compile-time error.
//
// Note: not all code is disabled in frameworks (most is)
// Note: some frameworks are intended to be used in testing and those don't have these conditional compilation flags.
//
// Table: (<> means that it is different from how it currently works)
//
// A: MIXBOX_ENABLE_ALL_FRAMEWORKS             | false | true  | false | true  | false | true  | false | true  |
// B: MIXBOX_ENABLE_FRAMEWORK_NAME_FRAMEWORK   | false | false | true  | true  | false | false | true  | true  |
// C: MIXBOX_DISABLE_FRAMEWORK_NAME_FRAMEWORK  | false | false | false | false | true  | true  | true  | true  |
// --------------------------------------------+-------+-------+-------+-------+-------+-------+-------+-------+
// (how it currently works)                    | false | true  | true  | true  | false | false | error | error |
// more complex logic (considered alternative) | false | true  | true  |<error>| false | false | error | error |
// (A && !C) || B (considered alternative)     | false | true  | true  | true  | false | false |<true >|<true >|
// (A || B) && !C (considered alternative)     | false | true  | true  | true  | false | false |<false>|<false>|
//
// Comments on user experience:
//
// User can choose whether they want to use whitelist or not (setting or not setting MIXBOX_ENABLE_ALL_FRAMEWORKS)
// If user goes with setting MIXBOX_ENABLE_ALL_FRAMEWORKS, they can disable some frameworks with MIXBOX_DISABLE_FRAMEWORK_NAME_FRAMEWORK (blacklist approach).
// If not, they can use MIXBOX_ENABLE_FRAMEWORK_NAME_FRAMEWORK (whitelist approach).
// If flags are conflicting (both MIXBOX_ENABLE_FRAMEWORK_NAME_FRAMEWORK & MIXBOX_DISABLE_FRAMEWORK_NAME_FRAMEWORK are present), raise error.
// The justification for this is that we don't know what to do with it and raising error is safe, and the behavior can be changed in the future.
//
// The only questionable flag combination is this: MIXBOX_ENABLE_ALL_FRAMEWORKS & MIXBOX_ENABLE_FRAMEWORK_NAME_FRAMEWORK (why to allow usage of both enabling flags?)
//
public final class IfClauseInfoByPathProviderImpl: IfClauseInfoByPathProvider {
    public init() {
    }
    
    public func ifClauseInfo(
        frameworkName: String,
        filePath: String
    ) -> IfClauseInfo? {
        let lastPathComponent = (filePath as NSString).lastPathComponent
        
        if exceptions.contains(lastPathComponent) {
            return nil
        } else {
            switch (filePath as NSString).pathExtension.lowercased() {
            case "swift":
                return ifClauseInfo(
                    frameworkName: frameworkName,
                    syntax: SwiftSyntax()
                )
            case "h", "c", "hh", "cc", "cpp", "hpp", "cxx", "hxx", "m", "mm", "c++":
                // Note: those extensions are somewhat popular, however, it doesn't include even all extensions from https://stackoverflow.com/a/3223792 (those are more exotic)
                return ifClauseInfo(
                    frameworkName: frameworkName,
                    syntax: CSyntax()
                )
            default:
                return nil
            }
        }
    }
    
    private func ifClauseInfo(
        frameworkName: String,
        syntax: Syntax
    ) -> IfClauseInfo {
        IfClauseInfoProvider(
            frameworkName: frameworkName,
            syntax: syntax,
            flagNamesProvider: FlagNamesProvider()
        ).ifClauseInfo()
    }
    
    private let exceptions: [String] = [
        "EnsureReleaseAppIsNotAffected.swift",
        "TestabilityElement.h",
        "TestabilityElementType.h",
        "NSObject+AccessibilityPlaceholderValue.h"
    ]
}

// Note: only works with Swift, C, C++, Objective-C, Objective-C++, relies on coincidences in languages (for sake of simplicity)
private class IfClauseInfoProvider {
    private let frameworkName: String
    private let syntax: Syntax
    private let all: String
    private let disabled: String
    private let enabled: String
    
    init(
        frameworkName: String,
        syntax: Syntax,
        flagNamesProvider: FlagNamesProvider
    ) {
        self.frameworkName = frameworkName
        self.syntax = syntax
        
        all = syntax.defined(
            flagName: flagNamesProvider.enableAllFrameworksFlagName
        )
        disabled = syntax.defined(
            flagName: flagNamesProvider.disableFrameworkFlagName(frameworkName: frameworkName)
        )
        enabled = syntax.defined(
            flagName: flagNamesProvider.enableFrameworkFlagName(frameworkName: frameworkName)
        )
    }
    
    func ifClauseInfo() -> IfClauseInfo {
        IfClauseInfo(
            disablingCompilation: disablingCompilationClause(),
            disablingCompilationComment: "// The compilation is disabled",
            enablingCompilation: syntax.hashElse,
            closing: syntax.hashEndIf
        )
    }
    
    private func disablingCompilationClause() -> String {
        """
        \(syntax.hashIf) \(enabled) && \(disabled)
        \(syntax.compileTimeError(messageLiteralWithoutQuotes: "\(frameworkName) is marked as both enabled and disabled, choose one of the flags"))
        \(syntax.hashElseIf) \(disabled) || (!\(all) && !\(enabled))
        """
    }
}

// Note: there is no escaping of anything, e.g. compileTimeError(messageLiteralWithoutQuotes: "foo\"bar") can produce #error "foo"bar" (for C)
private protocol Syntax {
    var hashElseIf: String { get }
    func defined(flagName: String) -> String
    func compileTimeError(messageLiteralWithoutQuotes: String) -> String
}

extension Syntax {
    var hashIf: String { "#if" }
    var hashElse: String { "#else" }
    var hashEndIf: String { "#endif" }
}

private class SwiftSyntax: Syntax {
    let hashElseIf = "#elseif"
    
    func defined(flagName: String) -> String {
        flagName
    }
    
    func compileTimeError(messageLiteralWithoutQuotes: String) -> String {
        """
        #error("\(messageLiteralWithoutQuotes)")
        """
    }
}

private class CSyntax: Syntax {
    let hashElseIf = "#elif"
    
    func defined(flagName: String) -> String {
        "defined(\(flagName))"
    }
    
    func compileTimeError(messageLiteralWithoutQuotes: String) -> String {
        """
        #error "\(messageLiteralWithoutQuotes)"
        """
    }
}
    
private final class FlagNamesProvider {
    let enableAllFrameworksFlagName = "MIXBOX_ENABLE_ALL_FRAMEWORKS"
    
    func enableFrameworkFlagName(frameworkName: String) -> String {
        "MIXBOX_ENABLE_FRAMEWORK_\(convertToUppercaseSnakeCase(camelCaseName: frameworkName))"
    }
    
    func disableFrameworkFlagName(frameworkName: String) -> String {
        "MIXBOX_DISABLE_FRAMEWORK_\(convertToUppercaseSnakeCase(camelCaseName: frameworkName))"
    }
    
    private func convertToUppercaseSnakeCase(camelCaseName: String) -> String {
        camelCaseName.enumerated().map { index, character in
            if index > 0 && character.isUppercase {
                return "_\(character.uppercased())"
            } else {
                return String(character.uppercased())
            }
        }.joined()
    }
}
