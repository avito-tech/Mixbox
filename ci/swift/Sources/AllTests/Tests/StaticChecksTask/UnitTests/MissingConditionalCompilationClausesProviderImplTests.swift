import Foundation
import CiFoundation
import XCTest
import StaticChecksTask

final class MissingConditionalCompilationClausesProviderImplTests: XCTestCase {
    func test() {
        do {
            let preparedFileSystem = try prepareFileSystem()
            let filesEnumerator = FilesEnumeratorImpl()
            
            let missingConditionalCompilationClausesProvider = MissingConditionalCompilationClausesProviderImpl(
                frameworkInfosProvider: FrameworkInfosProviderMock(
                    frameworkInfos: [
                        FrameworkInfo(
                            name: preparedFileSystem.frameworkName,
                            requiresConditionalCompilationClausesToDisableCodeInReleaseBuilds: true
                        )
                    ]
                ),
                filesEnumerator: filesEnumerator,
                mixboxFrameworksEnumerator: MixboxFrameworksEnumeratorImpl(
                    filesEnumerator: filesEnumerator,
                    frameworksDirectoryProvider: FrameworksDirectoryProviderMock(
                        frameworksDirectory: preparedFileSystem.frameworksDirectory
                    )
                ),
                ifClauseInfoByPathProvider: IfClauseInfoByPathProviderImpl()
            )
            
            let actualClauses = try missingConditionalCompilationClausesProvider
                .missingConditionalCompilationClauses()
            
            let expectedClauses = Set(preparedFileSystem.filesMissingIfs.map {
                MissingConditionalCompilationClause(
                    frameworkName: preparedFileSystem.frameworkName,
                    fileNameWithMissingClause: $0
                )
            })
            
            XCTAssertGreaterThan(actualClauses.count, 0)
            
            if actualClauses != expectedClauses {
                let fileNamesExpectedToHaveClauses = actualClauses.subtracting(expectedClauses).sorted().map { $0.fileNameWithMissingClause.lastPathComponent }
                let fileNamesExpectedToMissClauses = expectedClauses.subtracting(actualClauses).sorted().map { $0.fileNameWithMissingClause.lastPathComponent }
                
                XCTFail(
                    """
                    Actual clauses do not equal to expected clauses.
                                        
                    Following files are expected to have clauses: \(fileNamesExpectedToHaveClauses)
                    Following files are expected to miss clauses: \(fileNamesExpectedToMissClauses)
                    """
                )
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    private struct PreparedFileSystem {
        let frameworksDirectory: String
        let frameworkName: String
        let frameworkPath: String
        let filesMissingIfs: [String]
        let filesNotMissingIfs: [String]
    }
    
    // swiftlint:disable:next function_body_length
    private func prepareFileSystem() throws -> PreparedFileSystem {
        let temporaryFileProvider = TemporaryFileProviderImpl()
        
        let frameworksDirectory = temporaryFileProvider.temporaryFilePath()
        
        let frameworkName = "FooBar"
        let frameworkPath = "\(frameworksDirectory)/\(frameworkName)"
        
        try FileManager.default.createDirectory(
            atPath: frameworkPath,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        var filesMissingIfs = [String]()
        var filesNotMissingIfs = [String]()
        
        func makeFile(
            name: String,
            contents: String,
            missingIfs: Bool)
            throws
        {
            let fileName = "\(frameworkPath)/\(name)"
            
            try contents.write(
                toFile: fileName,
                atomically: true,
                encoding: .utf8
            )
            
            if filesMissingIfs.contains(fileName) || filesNotMissingIfs.contains(fileName) {
                XCTFail("Duplicated file name: \(fileName)")
            }
            
            if missingIfs {
                filesMissingIfs.append(fileName)
            } else {
                filesNotMissingIfs.append(fileName)
            }
        }
        
        let expectedSwiftFileContents = """
            #if MIXBOX_ENABLE_FRAMEWORK_FOO_BAR && MIXBOX_DISABLE_FRAMEWORK_FOO_BAR
            #error("FooBar is marked as both enabled and disabled, choose one of the flags")
            #elseif MIXBOX_DISABLE_FRAMEWORK_FOO_BAR || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOO_BAR)
            // The compilation is disabled
            #else
            """
        
        let expectedCFileContents = """
            #if defined(MIXBOX_ENABLE_FRAMEWORK_FOO_BAR) && defined(MIXBOX_DISABLE_FRAMEWORK_FOO_BAR)
            #error "FooBar is marked as both enabled and disabled, choose one of the flags"
            #elif defined(MIXBOX_DISABLE_FRAMEWORK_FOO_BAR) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_FOO_BAR))
            // The compilation is disabled
            #else
            """
        
        for fileExtension in ["swift"] {
            
            try makeFile(
                name: "fileMissingIfs.\(fileExtension)",
                contents:
                """
                class X {}
                """,
                missingIfs: true
            )
            
            try makeFile(
                name: "fileNotMissingIfs.\(fileExtension)",
                contents:
                """
                \(expectedSwiftFileContents)
                class X {}
                #endif
                """,
                missingIfs: false
            )
            
            try makeFile(
                name: "fileWithWrongIfs.\(fileExtension)",
                contents:
                """
                \(expectedCFileContents)
                class X {}
                #endif
                """,
                missingIfs: true
            )
        }
        
        for fileExtension in ["h", "c", "hh", "cc", "cpp", "hpp", "cxx", "hxx", "m", "mm", "c++"] {
            try makeFile(
                name: "fileNotMissingIfs.\(fileExtension)",
                contents:
                """
                \(expectedCFileContents)
                @import UIKit;
                #endif
                """,
                missingIfs: false
            )
            
            try makeFile(
                name: "fileWithWrongIfs.\(fileExtension)",
                contents:
                """
                \(expectedSwiftFileContents)
                @import UIKit;
                #endif
                """,
                missingIfs: true
            )
            
            try makeFile(
                name: "fileMissingIfs.\(fileExtension)",
                contents:
                """
                @import UIKit;
                """,
                missingIfs: true
            )
        }
        
        try makeFile(
            name: "nonSwiftFile.json",
            contents:
            """
            {
                "j": "son"
            }
            """,
            missingIfs: false
        )
        
        return PreparedFileSystem(
            frameworksDirectory: frameworksDirectory,
            frameworkName: frameworkName,
            frameworkPath: frameworkPath,
            filesMissingIfs: filesMissingIfs,
            filesNotMissingIfs: filesNotMissingIfs
        )
    }
}
