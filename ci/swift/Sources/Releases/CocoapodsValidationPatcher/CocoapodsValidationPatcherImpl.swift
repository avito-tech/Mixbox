import Git
import Bundler
import Foundation
import CiFoundation

public final class CocoapodsValidationPatcherImpl: CocoapodsValidationPatcher {
    private let bundledProcessExecutor: BundledProcessExecutor
    
    public init(
        bundledProcessExecutor: BundledProcessExecutor)
    {
        self.bundledProcessExecutor = bundledProcessExecutor
    }
    
    public func setPodspecValidationEnabled(_ enabled: Bool) throws {
        let file = try pathToPushRb()
        
        let uncommentedLine = "  validate_podspec_files"
        let commentedLine = "  # patched using mixbox # validate_podspec_files"
        
        if enabled {
            _ = try patch(
                file: file,
                pattern: commentedLine,
                replacement: uncommentedLine
            )
        } else {
            let patched = try patch(
                file: file,
                pattern: uncommentedLine,
                replacement: commentedLine
            )
            
            if !patched {
                throw ErrorString("Failed to patch cocoapods")
            }
        }
    }
    
    private func patch(
        file: String,
        pattern: String,
        replacement: String)
        throws
        -> Bool
    {
        let oldContents = try String(contentsOfFile: file, encoding: .utf8)
        
        let regex = try NSRegularExpression(
            pattern: pattern,
            options: []
        )
        
        let newContents = regex.stringByReplacingMatches(
            in: oldContents,
            options: [],
            range: NSRange(location: 0, length: oldContents.utf16.count),
            withTemplate: replacement
        )
        
        if newContents == oldContents {
            return false
        } else {
            try newContents.write(
                toFile: file,
                atomically: true,
                encoding: .utf8
            )
            
            return true
        }
    }
    
    private func pathToPushRb() throws -> String {
        return try cocoapodsLibPath().appending(
            pathComponents: [
                "lib",
                "cocoapods",
                "command",
                "repo",
                "push.rb"
            ]
        )
    }
    
    private func cocoapodsLibPath() throws -> String {
        let arguments = ["gem", "which", "cocoapods"]
        
        let result = try bundledProcessExecutor.execute(
            arguments: arguments,
            currentDirectory: nil,
            environment: nil
        )
        
        if result.code != 0 {
            throw ErrorString("Failed to execute \(arguments.joined(separator: " "))")
        }
        
        let pathToCocoapodsRb = try result.stdout.trimmedUtf8String().unwrapOrThrow()
        
        // /Users/xxxx/.rvm/gems/ruby-2.4.1/gems/cocoapods-1.10.0/lib/cocoapods.rb
        // ^------------------- we need this -------------------^
        
        return pathToCocoapodsRb
            .deletingLastPathComponent
            .deletingLastPathComponent
    }
}
