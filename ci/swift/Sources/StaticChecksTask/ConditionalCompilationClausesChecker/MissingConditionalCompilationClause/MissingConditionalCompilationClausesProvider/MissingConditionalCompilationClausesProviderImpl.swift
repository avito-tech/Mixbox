import Foundation
import CiFoundation

public final class MissingConditionalCompilationClausesProviderImpl: MissingConditionalCompilationClausesProvider {
    private let frameworksDirectoryProvider: FrameworksDirectoryProvider
    private let frameworkInfosProvider: FrameworkInfosProvider
    private let ifClauseInfoByPathProvider: IfClauseInfoByPathProvider
    
    public init(
        frameworksDirectoryProvider: FrameworksDirectoryProvider,
        frameworkInfosProvider: FrameworkInfosProvider,
        ifClauseInfoByPathProvider: IfClauseInfoByPathProvider)
    {
        self.frameworksDirectoryProvider = frameworksDirectoryProvider
        self.frameworkInfosProvider = frameworkInfosProvider
        self.ifClauseInfoByPathProvider = ifClauseInfoByPathProvider
    }
    
    public func missingConditionalCompilationClauses()
        throws
        -> [MissingConditionalCompilationClause]
    {
        let frameworkInfoByName = try self.frameworkInfoByName()
        var missingConditionalCompilationClauses = [MissingConditionalCompilationClause]()
        
        try enumerateFrameworks { frameworkDirectory, frameworkName in
            guard let frameworkInfo = frameworkInfoByName[frameworkName] else {
                throw ErrorString("Framework is unknown: \(frameworkDirectory)")
            }
            
            missingConditionalCompilationClauses.append(
                contentsOf: try self.missingConditionalCompilationClauses(
                    frameworkInfo: frameworkInfo,
                    frameworkDirectory: frameworkDirectory
                )
            )
        }
        
        return missingConditionalCompilationClauses
    }
    
    // MARK: - Private
    
    private func enumerateFrameworks(
        handler: (_ frameworkDirectory: String, _ frameworkName: String) throws -> ())
        throws
    {
        try enumerateFiles(
            directory: frameworksDirectoryProvider.frameworksDirectory(),
            handler: { enumerator, path in
                var isDirectory: ObjCBool = false
                
                if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        let frameworkName = (path as NSString).lastPathComponent
                        
                        try handler(path, frameworkName)
                    }
                }
                
                enumerator.skipDescendants()
            }
        )
    }
    
    private func missingConditionalCompilationClauses(
        frameworkInfo: FrameworkInfo,
        frameworkDirectory: String)
        throws
        -> [MissingConditionalCompilationClause]
    {
        var missingConditionalCompilationClauses = [MissingConditionalCompilationClause]()
        
        if frameworkInfo.needsIfs {
            let filesMissingConditionalCompilationClauses = try self.filesMissingConditionalCompilationClauses(
                frameworkDirectory: frameworkDirectory
            )
            
            for file in filesMissingConditionalCompilationClauses {
                missingConditionalCompilationClauses.append(
                    MissingConditionalCompilationClause(
                        frameworkName: frameworkInfo.name,
                        fileNameWithMissingClause: file
                    )
                )
            }
        }
        
        return missingConditionalCompilationClauses
    }
    
    private func filesMissingConditionalCompilationClauses(
        frameworkDirectory: String)
        throws
        -> [String]
    {
        var filesWithoutIfs = [String]()
        
        try enumerateFiles(directory: frameworkDirectory) { _, path in
            if let expectedContents = expectedContentsByFileExtension(path: path) {
                let contents = try String(contentsOf: URL(fileURLWithPath: path))
                
                if !contents.contains(expectedContents) {
                    filesWithoutIfs.append(path)
                }
            }
        }
        
        return filesWithoutIfs
    }
    
    private func expectedContentsByFileExtension(path: String) -> String? {
        return ifClauseInfoByPathProvider.ifClauseInfo(path: path)?.clauseOpening
    }
    
    private func enumerateFiles(
        directory: String,
        handler: (_ enumerator: FileManager.DirectoryEnumerator, _ url: String) throws -> ())
        throws
    {
        if let enumerator = FileManager.default.enumerator(atPath: directory) {
            for case let path as String in enumerator {
                try handler(enumerator, "\(directory)/\(path)")
            }
        } else {
            throw ErrorString("Failed to create enumerator of directory \(directory)")
        }
    }
    
    private func frameworkInfoByName() throws -> [String: FrameworkInfo] {
        var frameworkInfoByName = [String: FrameworkInfo]()
        
        for frameworkInfo in frameworkInfosProvider.frameworkInfos() {
            frameworkInfoByName[frameworkInfo.name] = frameworkInfo
        }
        
        return frameworkInfoByName
    }
}
