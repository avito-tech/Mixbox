import Foundation
import CiFoundation
import Git
import Darwin

public final class ConditionalCompilationClausesCheckerImpl: ConditionalCompilationClausesChecker {
    private let missingConditionalCompilationClausesProvider: MissingConditionalCompilationClausesProvider
    
    public init(
        missingConditionalCompilationClausesProvider: MissingConditionalCompilationClausesProvider)
    {
        self.missingConditionalCompilationClausesProvider = missingConditionalCompilationClausesProvider
    }
    
    public func checkConditionalCompilationClauses() throws {
        let missingConditionalCompilationClauses = try missingConditionalCompilationClausesProvider
            .missingConditionalCompilationClauses()
        
        if !missingConditionalCompilationClauses.isEmpty {
            let listOfFiles = missingConditionalCompilationClauses
                .map { $0.fileNameWithMissingClause }
                .joined(separator: "\n")
            
            fputs("The following files do not contain #if:\n\n\(listOfFiles)\n\n", stderr)
            
            throw ErrorString("Some files are missing #if clauses")
        }
    }
}
