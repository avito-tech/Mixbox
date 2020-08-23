import Foundation
import CiFoundation

public final class CocoapodsSearchImpl: CocoapodsSearch {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    private let environmentProvider: EnvironmentProvider
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor,
        environmentProvider: EnvironmentProvider)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
        self.environmentProvider = environmentProvider
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
            
            // TBD
            
            return CocoapodsSearchResult()
        } catch {
            throw ErrorString("Failed to search pod with name \(name): \(error)")
        }
    }
}
