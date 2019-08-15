import Foundation
import CiFoundation
import Git
import Darwin

public final class ConditionalCompilationClausesCheckerImpl: ConditionalCompilationClausesChecker {
    private let missingConditionalCompilationClausesProvider: MissingConditionalCompilationClausesProvider
    private let missingConditionalCompilationClausesAutocorrector: MissingConditionalCompilationClausesAutocorrector
    
    public init(
        missingConditionalCompilationClausesProvider: MissingConditionalCompilationClausesProvider,
        missingConditionalCompilationClausesAutocorrector: MissingConditionalCompilationClausesAutocorrector)
    {
        self.missingConditionalCompilationClausesProvider = missingConditionalCompilationClausesProvider
        self.missingConditionalCompilationClausesAutocorrector = missingConditionalCompilationClausesAutocorrector
    }
    
    public func checkConditionalCompilationClauses() throws {
        let missingConditionalCompilationClauses = try missingConditionalCompilationClausesProvider
            .missingConditionalCompilationClauses()
        
        if !missingConditionalCompilationClauses.isEmpty {
            let fileNames = missingConditionalCompilationClauses
                .map { $0.fileNameWithMissingClause }
            
            let listOfFiles = fileNames
                .joined(separator: "\n")
            
            fputs("The following files do not contain #if:\n\n\(listOfFiles)\n\nRun this build with MIXBOX_CI_AUTOCORRECT_ENABLED=true to autocorrect it.\n\n", stderr)
            
            if ProcessInfo.processInfo.environment["MIXBOX_CI_AUTOCORRECT_ENABLED"] == "true" {
                try missingConditionalCompilationClausesAutocorrector.autocorrect(
                    missingConditionalCompilationClauses: missingConditionalCompilationClauses
                )
            }
            
            throw ErrorString("Some files are missing #if clauses")
        }
    }
}
