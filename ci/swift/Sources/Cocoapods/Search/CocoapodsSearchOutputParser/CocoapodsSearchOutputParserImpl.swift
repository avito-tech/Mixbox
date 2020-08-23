import Foundation
import CiFoundation

public final class CocoapodsSearchOutputParserImpl: CocoapodsSearchOutputParser {
    public init() {
    }
    
    public func parse(output: String) throws -> CocoapodsSearchResult {
        let scanner = ThrowingScannerImpl(string: output)
        
        return try scanner.scan()
    }
}

private extension ThrowingScanner {
    // Example:
    //
    // ```
    // -> MixboxFoundation (0.2.3)
    //    Shared simple general purpose utilities
    //    pod 'MixboxFoundation', '~> 0.2.3'
    //    - Homepage: https://github.com/avito-tech/Mixbox
    //    - Source:
    //    http://security.champion.imma/repository/ios-speed-cocoapods-proxy/pods/MixboxFoundation/0.2.3/https/api.github.com/repos/avito-tech/Mixbox/tarball/Mixbox-0.2.3.tar.gz
    //    - Versions: 0.2.3, 0.2.2, 0.2.1, 0.2.0, 0.0.2, 0.0.1 [avito-repository-ios-speed-cocoapods-proxy repo] - 0.2.3, 0.2.2, 0.2.1, 0.2.0, 0.0.2, 0.0.1 [cocoapods repo] - 0.2.3,
    //    0.2.2, 0.2.1, 0.2.0, 0.0.2, 0.0.1 [trunk repo]
    //    - Author:   Hive of coders from Avito
    //    - License:  MIT
    //    - Platform: iOS 9.0 - macOS 10.13
    //    - Stars:    1
    //    - Forks:    0
    // ```
    func scan() throws -> CocoapodsSearchResult {
        var pods = [CocoapodsSearchResult.Pod]()
        
        while !isAtEnd {
            // -> MixboxFoundation (0.2.3)
            try scanPass("-> ")
            let name = try scanPass(.whitespacesAndNewlines)
            try scanWhile("(")
            let latestVersion = try scanPass(")")
            
            //    Shared simple general purpose utilities
            try scanPass(.whitespacesAndNewlines)
            let description = try scanPass("\n")
            
            //    pod 'MixboxFoundation', '~> 0.2.3'
            try scanPass(.whitespacesAndNewlines)
            let usage = try scanPass("\n")
            
            //    - Homepage: https://github.com/avito-tech/Mixbox
            //    ...etc...
            
            let dictionary = try scanDictionary()
            
            let pod = CocoapodsSearchResult.Pod(
                name: name,
                latestVersion: latestVersion,
                description: description,
                usage: usage,
                homepage: dictionary["Homepage"],
                source: dictionary["Source"],
                versions: try dictionary["Versions"].map { try versions(string: $0) },
                author: dictionary["Author"],
                license: dictionary["License"],
                platforms: try dictionary["Platform"].map { try platforms(string: $0) },
                stars: dictionary["Stars"].flatMap { Int($0) },
                forks: dictionary["Forks"].flatMap { Int($0) }
            )
            
            pods.append(pod)
        }
        
        return CocoapodsSearchResult(
            pods: pods
        )
    }
    
    private func versions(string: String) throws -> [String: [String]] {
        // 0.2.3, 0.2.2, 0.2.1, 0.2.0, 0.0.2, 0.0.1 [avito-repository-ios-speed-cocoapods-proxy repo] - 0.2.3, 0.2.2, 0.2.1, 0.2.0, 0.0.2, 0.0.1 [cocoapods repo]
        
        var result = [String: [String]]()
        
        try (string as NSString).components(separatedBy: " - ").forEach { component in
            let versionsAndRepo = (component as NSString).components(separatedBy: " [")
            
            if versionsAndRepo.count != 2 {
                throw ErrorString("Failed to parse versions from \(versionsAndRepo)")
            } else {
                let versions = (versionsAndRepo[0] as NSString).components(separatedBy: ", ")
                
                let scanner = ThrowingScannerImpl(string: versionsAndRepo[1])
                
                let repo = try scanner.scanUntil(" ")
                
                result[repo] = versions
            }
        }
        
        return result
    }
    
    private func platforms(string: String) throws -> [String: String] {
        var result = [String: String]()
        
        // iOS 9.0 - macOS 10.13
        
        try (string as NSString).components(separatedBy: " - ").forEach {
            let keyValue = ($0 as NSString).components(separatedBy: " ")
            
            if keyValue.count != 2 {
                throw ErrorString("Failed to scan platforms: \(keyValue)")
            } else {
                let key = keyValue[0]
                let value = keyValue[1]
                result[key] = value
            }
        }
        
        return result
    }
    
    private func scanDictionary() throws -> [String: String] {
        var dictionary = [String: String]()
        
        try scanPass("   - ")
        
        do {
            while !isAtEnd {
                let key = try scanPass(":")
                
                try scanWhile(.whitespacesAndNewlines)

                do {
                    let value = try scanPass("   - ")
                    
                    dictionary[key] = trim(dictionaryValue: value)
                } catch {
                    do {
                        let value = try scanPass("->")
                        
                        dictionary[key] = trim(dictionaryValue: value)
                    } catch {
                        let value = try scanToEnd()
                        
                        dictionary[key] = trim(dictionaryValue: value)
                    }
                }
                
            }
        } catch {
        }
        
        return dictionary
    }
    
    private func trim(dictionaryValue: String) -> String {
        return dictionaryValue
            .split(separator: "\n", omittingEmptySubsequences: true)
            .map {
                $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            .joined(separator: " ")
    }
}
