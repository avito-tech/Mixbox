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
            
            let missingConditionalCompilationClauses = try missingConditionalCompilationClausesProvider
                .missingConditionalCompilationClauses()
            
            XCTAssertGreaterThan(missingConditionalCompilationClauses.count, 0)
            XCTAssertEqual(
                missingConditionalCompilationClauses.sorted(),
                preparedFileSystem.filesMissingIfs.map {
                    MissingConditionalCompilationClause(
                        frameworkName: preparedFileSystem.frameworkName,
                        fileNameWithMissingClause: $0
                    )
                }.sorted()
            )
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
        
        let frameworkName = "Framework"
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
        
        try makeFile(
            name: "fileMissingIfs.swift",
            contents:
            """
            class X {}
            """,
            missingIfs: true
        )
        
        try makeFile(
            name: "fileMissingIfs.h",
            contents:
            """
            @import UIKit;
            """,
            missingIfs: true
        )
        
        try makeFile(
            name: "fileMissingIfs.m",
            contents:
            """
            @import UIKit;
            """,
            missingIfs: true
        )
        
        try makeFile(
            name: "fileMissingIfs.mm",
            contents:
            """
            @import UIKit;
            """,
            missingIfs: true
        )
        
        try makeFile(
            name: "fileMissingIfs.c",
            contents:
            """
            @import UIKit;
            """,
            missingIfs: true
        )
        
        try makeFile(
            name: "fileNotMissingIfs.swift",
            contents:
            """
            #if MIXBOX_ENABLE_IN_APP_SERVICES
            class X {}
            #endif
            """,
            missingIfs: false
        )
        
        try makeFile(
            name: "fileNotMissingIfs.h",
            contents:
            """
            #ifdef MIXBOX_ENABLE_IN_APP_SERVICES
            @import UIKit;
            #endif
            """,
            missingIfs: false
        )
        
        try makeFile(
            name: "fileNotMissingIfs.m",
            contents:
            """
            #ifdef MIXBOX_ENABLE_IN_APP_SERVICES
            @import UIKit;
            #endif
            """,
            missingIfs: false
        )
        
        try makeFile(
            name: "fileNotMissingIfs.mm",
            contents:
            """
            #ifdef MIXBOX_ENABLE_IN_APP_SERVICES
            @import UIKit;
            #endif
            """,
            missingIfs: false
        )
        
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
        
        try makeFile(
            name: "fileWithWrongIfs.swift",
            contents:
            """
            #ifdef MIXBOX_ENABLE_IN_APP_SERVICES
            class X {}
            #endif
            """,
            missingIfs: true
        )
        
        try makeFile(
            name: "fileWithWrongIfs.hh",
            contents:
            """
            #if MIXBOX_ENABLE_IN_APP_SERVICES
            @import UIKit;
            #endif
            """,
            missingIfs: true
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
