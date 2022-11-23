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
    
    public func missingConditionalCompilationClauses(
    ) throws -> Set<MissingConditionalCompilationClause> {
        let frameworkInfoByName = try self.frameworkInfoByName()
        var missingConditionalCompilationClauses = Set<MissingConditionalCompilationClause>()
        
        try mixboxFrameworksEnumerator.enumerateFrameworks { frameworkDirectory, frameworkName in
            guard let frameworkInfo = frameworkInfoByName[frameworkName] else {
                throw ErrorString("Framework is unknown: \(frameworkDirectory)")
            }
            
            missingConditionalCompilationClauses.formUnion(
                try self.missingConditionalCompilationClauses(
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
        frameworkDirectory: String
    ) throws -> Set<MissingConditionalCompilationClause> {
        var missingConditionalCompilationClauses = Set<MissingConditionalCompilationClause>()
        
        if frameworkInfo.requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds {
            let filesMissingConditionalCompilationClauses = try self.filesMissingConditionalCompilationClauses(
                frameworkName: frameworkInfo.name,
                frameworkDirectory: frameworkDirectory
            )
            
            for file in filesMissingConditionalCompilationClauses {
                missingConditionalCompilationClauses.insert(
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
        frameworkName: String,
        frameworkDirectory: String)
        throws
        -> [String]
    {
        var filesWithoutIfs = [String]()
        
        try filesEnumerator.enumerateFiles(directory: frameworkDirectory) { _, filePath in
            if let ifClauseInfo = ifClauseInfoByPathProvider.ifClauseInfo(
                frameworkName: frameworkName,
                filePath: filePath
            ) {
                let contents = try String(contentsOf: URL(fileURLWithPath: filePath))
                
                let requiredCodeParts = [
                    ifClauseInfo.disablingCompilation,
                    ifClauseInfo.enablingCompilation,
                    ifClauseInfo.closing
                ]
                
                if !requiredCodeParts.allSatisfy({ contents.contains($0) }) {
                    filesWithoutIfs.append(filePath)
                }
            }
        }
        
        return filesWithoutIfs
    }
    
    private func frameworkInfoByName() throws -> [String: FrameworkInfo] {
        var frameworkInfoByName = [String: FrameworkInfo]()
        
        for frameworkInfo in frameworkInfosProvider.frameworkInfos() {
            frameworkInfoByName[frameworkInfo.name] = frameworkInfo
        }
        
        return frameworkInfoByName
    }
}
