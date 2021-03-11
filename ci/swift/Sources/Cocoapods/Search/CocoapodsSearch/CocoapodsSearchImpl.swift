import Foundation
import CiFoundation

public final class CocoapodsSearchImpl: CocoapodsSearch {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    private let environmentProvider: EnvironmentProvider
    private let cocoapodsSearchOutputParser: CocoapodsSearchOutputParser
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor,
        environmentProvider: EnvironmentProvider,
        cocoapodsSearchOutputParser: CocoapodsSearchOutputParser)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
        self.environmentProvider = environmentProvider
        self.cocoapodsSearchOutputParser = cocoapodsSearchOutputParser
    }
    
    public func search(
        name: String)
        throws
        -> CocoapodsSearchResult
    {
        do {
            let result = try cocoapodsCommandExecutor.execute(
                arguments: ["search", "--no-pager", "--ios", "--simple", "--stats", "--no-ansi", name]
            )
            
            guard let output = result.stdout.trimmedUtf8String() else {
                throw ErrorString("Unexpected lack of output form `pod search`")
            }
            
            return try cocoapodsSearchOutputParser.parse(output: output)
        } catch {
            throw ErrorString("Failed to search pod with name \(name): \(error)")
        }
    }
}
