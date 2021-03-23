import Foundation
import CiFoundation

public final class CocoapodsTrunkInfoOutputParserImpl: CocoapodsTrunkInfoOutputParser {
    public init() {
    }
    
    public func parse(output: String) throws -> CocoapodsTrunkInfoResult {
        let scanner = ThrowingScannerImpl(string: output)
        
        return try scanner.scanResult()
    }
}

private extension ThrowingScanner {
    // MixboxFoundation
    //     - Versions:
    //       - 0.0.1 (2018-08-07 13:14:13 UTC)
    //       - 0.0.2 (2019-02-26 08:06:45 UTC)
    //     - Owners:
    //       - Artyom Razinov <artyom.razinov@gmail.com>
    //       - Artyom Razinov <arazinov@avito.ru>
    func scanResult() throws -> CocoapodsTrunkInfoResult {
        // MixboxFoundation
        let podName = try scanUntil(.whitespacesAndNewlines)
        
        let versions = try scanVersions()
        let owners = try scanOwners()
        
        return CocoapodsTrunkInfoResult(
            podName: podName,
            versions: versions,
            owners: owners
        )
    }
    
    func scanVersions() throws -> [CocoapodsTrunkInfoResult.Version] {
        var versions = [CocoapodsTrunkInfoResult.Version]()
        
        try scanWhile(.whitespacesAndNewlines)
        try scanWhile("- Versions:\n")
        
        let scanner = ThrowingScannerImpl(
            string: try scanPass("- Owners:\n")
        )
        
        do {
            while !scanner.isAtEnd {
                try scanner.scanWhile(.whitespacesAndNewlines)
                
                // - 0.0.1 (2018-08-07 13:14:13 UTC)
                
                try scanner.scanWhile("- ")
                
                let versionString = try scanner.scanPass(" (")
                let dateString = try scanner.scanPass(")")
                
                versions.append(
                    .init(
                        versionString: versionString,
                        releaseDate: try date(dateString: dateString)
                    )
                )
            }
        } catch {
        }
        
        return versions
    }
    
    func scanOwners() throws -> [CocoapodsTrunkInfoResult.Owner] {
        var owners = [CocoapodsTrunkInfoResult.Owner]()
        
        do {
            while !isAtEnd {
                try scanWhile(.whitespacesAndNewlines)
                
                // - Artyom Razinov <artyom.razinov@gmail.com>
                
                try scanWhile("- ")
                
                let name = try scanPass(" <")
                let email = try scanPass(">")
                
                owners.append(
                    .init(
                        name: name,
                        email: email
                    )
                )
            }
        } catch {
        }
        
        return owners
    }
    
    func date(dateString: String) throws -> Date {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        dateFormatter.dateFormat = dateFormat
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            throw ErrorString("Failed to parse date with format '\(dateFormat)' from '\(dateString)'")
        }
    }
}
