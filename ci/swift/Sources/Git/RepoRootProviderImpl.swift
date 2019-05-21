import Foundation
import CiFoundation

public final class RepoRootProviderImpl: RepoRootProvider {
    public init() {
    }
    
    // TODO: More clever solution. This function just searches for `.git`. `git rev-parse --show-toplevel` works better.
    // TODO: Find a way to not use #file
    public func repoRootPath() throws -> String {
        var root = #file
        
        if Foundation.FileManager.default.fileExists(atPath: root) {
            while !Foundation.FileManager.default.fileExists(atPath: "\(root)/.git") && root.count > 1 {
                root = (root as NSString).deletingLastPathComponent
            }
        }
        
        if Foundation.FileManager.default.fileExists(atPath: "\(root)/.git") {
            return root
        } else {
            throw ErrorString("git repo was not found  in this file location \(root)")
        }
    }
}
