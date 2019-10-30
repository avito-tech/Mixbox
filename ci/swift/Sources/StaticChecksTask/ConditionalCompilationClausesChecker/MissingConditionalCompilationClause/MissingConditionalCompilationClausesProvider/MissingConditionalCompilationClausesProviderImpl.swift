import Foundation
import CiFoundation

public final class MissingConditionalCompilationClausesProviderImpl: MissingConditionalCompilationClausesProvider {
    private let frameworkInfosProvider: FrameworkInfosProvider
    private let filesEnumerator: FilesEnumerator
    private let mixboxFrameworksEnumerator: MixboxFrameworksEnumerator
    private let ifClauseInfoByPathProvider: IfClauseInfoByPathProvider
    
    public init(
        frameworkInfosProvider: FrameworkInfosProvider,
        filesEnumerator: FilesEnumerator,
        mixboxFrameworksEnumerator: MixboxFrameworksEnumerator,
        ifClauseInfoByPathProvider: IfClauseInfoByPathProvider)
    {
        self.frameworkInfosProvider = frameworkInfosProvider
        self.filesEnumerator = filesEnumerator
        self.mixboxFrameworksEnumerator = mixboxFrameworksEnumerator
        self.ifClauseInfoByPathProvider = ifClauseInfoByPathProvider
    }
    
    public func missingConditionalCompilationClauses()
        throws
        -> [MissingConditionalCompilationClause]
    {
        let frameworkInfoByName = try self.frameworkInfoByName()
        var missingConditionalCompilationClauses = [MissingConditionalCompilationClause]()
        
        try mixboxFrameworksEnumerator.enumerateFrameworks { frameworkDirectory, frameworkName in
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
    
    private func missingConditionalCompilationClauses(
        frameworkInfo: FrameworkInfo,
        frameworkDirectory: String)
        throws
        -> [MissingConditionalCompilationClause]
    {
        var missingConditionalCompilationClauses = [MissingConditionalCompilationClause]()
        
        if frameworkInfo.requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds {
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
        
        try filesEnumerator.enumerateFiles(directory: frameworkDirectory) { _, path in
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
    
    private func frameworkInfoByName() throws -> [String: FrameworkInfo] {
        var frameworkInfoByName = [String: FrameworkInfo]()
        
        for frameworkInfo in frameworkInfosProvider.frameworkInfos() {
            frameworkInfoByName[frameworkInfo.name] = frameworkInfo
        }
        
        return frameworkInfoByName
    }
}
