import StaticChecksTask
import Bash
import XCTest
import CiFoundation

final class IfClauseInfoByPathProviderImplTests: XCTestCase {
    func test___swift() {
        check(checker: SwiftChecker())
    }
    
    func test___c() {
        check(checker: CChecker())
    }
    
    private func check(
        checker: Checker
    ) {
        // Table is from comment from `IfClauseInfoByPathProviderImpl.swift`
        // swiftlint:disable comma operator_usage_whitespace
        let enableAll =                        [false, true,  false, true,  false, true,  false,  true]
        let enableFramework =                  [false, false, true,  true,  false, false, true,   true]
        let disableFramework =                 [false, false, false, false, true,  true,  true,   true]
        let codeIsCompiled: [CodeIsCompiled] = [.no,   .yes,  .yes,  .yes,  .no,   .no,   .error, .error]
        // swiftlint:enable comma operator_usage_whitespace
        
        XCTAssertEqual(enableAll.count, enableFramework.count)
        XCTAssertEqual(enableAll.count, disableFramework.count)
        XCTAssertEqual(enableAll.count, codeIsCompiled.count)
        
        assertDoesntThrow {
            for i in 0..<enableAll.count {
                try checker.check(
                    checkerData: CheckerData(
                        enableAll: enableAll[i],
                        enableFramework: enableFramework[i],
                        disableFramework: disableFramework[i],
                        expectedResult: codeIsCompiled[i]
                    )
                )
            }
        }
    }
}

private struct CheckerData {
    let enableAll: Bool
    let enableFramework: Bool
    let disableFramework: Bool
    let expectedResult: CodeIsCompiled
}

private enum CodeIsCompiled: String, Equatable {
    case error
    case yes
    case no
}

private protocol Checker {
    var fileName: String { get }
    
    func fileContents(
        ifClauseInfo: IfClauseInfo,
        fileName: String
    ) -> String
    
    // .yes if code inside #if clauses is compiled, .no otherwise, .error for compile time error
    func codeIsCompiled(
        checkerData: CheckerData,
        fileContents: String,
        workingDirectory: String,
        fileName: String
    ) throws -> CodeIsCompiled
}

private extension Checker {
    func check(
        checkerData: CheckerData
    ) throws {
        let temporaryFileProvider = TemporaryFileProviderImpl()
        
        let workingDirectory = temporaryFileProvider.temporaryFilePath()
        
        try FileManager.default.createDirectory(
            atPath: workingDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        let fileContents = try fileContents(fileName: fileName)
        
        let actualResult = try codeIsCompiled(
            checkerData: checkerData,
            fileContents: fileContents,
            workingDirectory: workingDirectory,
            fileName: fileName
        )
        
        XCTAssertEqual(
            actualResult,
            checkerData.expectedResult,
            """
            actualResult: \(actualResult)
            expectedResult: \(checkerData.expectedResult)
            enableAll: \(checkerData.enableAll)
            enableFramework: \(checkerData.enableFramework)
            disableFramework: \(checkerData.disableFramework),
            fileContents: \(fileContents)
            """
        )
    }
    
    func fileContents(
        fileName: String
    ) throws -> String {
        let provider: IfClauseInfoByPathProvider = IfClauseInfoByPathProviderImpl()
        
        return try fileContents(
            ifClauseInfo: provider.ifClauseInfo(
                frameworkName: "FooBar",
                filePath: fileName
            ).unwrapOrThrow(),
            fileName: fileName
        )
    }
    
    // Suitable for C and Swift
    func definesArguments(
        checkerData: CheckerData
    ) -> [String] {
        var arguments = [String]()
        
        if checkerData.enableAll {
            arguments.append(contentsOf: ["-D", "MIXBOX_ENABLE_ALL_FRAMEWORKS"])
        }
        if checkerData.enableFramework {
            arguments.append(contentsOf: ["-D", "MIXBOX_ENABLE_FRAMEWORK_FOO_BAR"])
        }
        if checkerData.disableFramework {
            arguments.append(contentsOf: ["-D", "MIXBOX_DISABLE_FRAMEWORK_FOO_BAR"])
        }
        
        return arguments
    }
}

private class SwiftChecker: Checker {
    let fileName = "filename.swift"
    
    func fileContents(
        ifClauseInfo: IfClauseInfo,
        fileName: String
    ) -> String {
        """
        \(ifClauseInfo.disablingCompilation)
        print("\(CodeIsCompiled.no)")
        \(ifClauseInfo.enablingCompilation)
        print("\(CodeIsCompiled.yes)")
        \(ifClauseInfo.closing)
        """
    }
    
    func codeIsCompiled(
        checkerData: CheckerData,
        fileContents: String,
        workingDirectory: String,
        fileName: String
    ) throws -> CodeIsCompiled {
        try codeIsCompiled(
            processResult: compileAndRunCode(
                checkerData: checkerData,
                fileContents: fileContents,
                workingDirectory: workingDirectory,
                fileName: fileName
            )
        )
    }
    
    private func compileAndRunCode(
        checkerData: CheckerData,
        fileContents: String,
        workingDirectory: String,
        fileName: String
    ) throws -> ProcessResult {
        let processExecutor: ProcessExecutor = FoundationProcessExecutor()
        
        var arguments = ["/usr/bin/swift"]
        
        arguments.append(contentsOf: definesArguments(checkerData: checkerData))
        arguments.append(fileName)
        
        try fileContents.write(
            toFile: "\(workingDirectory)/\(fileName)",
            atomically: true,
            encoding: .utf8
        )
        
        return try processExecutor.execute(
            arguments: arguments,
            currentDirectory: workingDirectory,
            environment: [:],
            outputHandling: .ignore
        )
    }
    
    private func codeIsCompiled(
        processResult: ProcessResult
    ) throws -> CodeIsCompiled {
        if processResult.code == 0 {
            switch processResult.stdout.trimmedUtf8String() {
            case CodeIsCompiled.yes.rawValue:
                return .yes
            case CodeIsCompiled.no.rawValue:
                return .no
            default:
                throw "Unexpected output: \(processResult.stdout)"
            }
        } else {
            return .error
        }
    }
}

private class CChecker: Checker {
    let fileName = "filename.c"
    
    func fileContents(
        ifClauseInfo: IfClauseInfo,
        fileName: String
    ) -> String {
        """
        #include <stdio.h>

        int main() {
            \(ifClauseInfo.disablingCompilation.indent())
            puts("no");
            \(ifClauseInfo.enablingCompilation.indent())
            puts("yes");
            \(ifClauseInfo.closing.indent())
            return 0;
        }
        """
    }
    
    func codeIsCompiled(
        checkerData: CheckerData,
        fileContents: String,
        workingDirectory: String,
        fileName: String
    ) throws -> CodeIsCompiled {
        let processExecutor: ProcessExecutor = FoundationProcessExecutor()
        
        let executableName = "executable"
        
        var arguments = ["/usr/bin/gcc"]
        
        arguments.append(contentsOf: definesArguments(checkerData: checkerData))
        arguments.append(contentsOf: [fileName, "-o", "executable"])
        
        try fileContents.write(
            toFile: "\(workingDirectory)/\(fileName)",
            atomically: true,
            encoding: .utf8
        )
        
        let compilationResult = try processExecutor.execute(
            arguments: arguments,
            currentDirectory: workingDirectory,
            environment: [:],
            outputHandling: .ignore
        )
        
        if compilationResult.code != 0 {
            return .error
        } else {
            let runningResult = try processExecutor.execute(
                arguments: ["\(workingDirectory)/\(executableName)"],
                currentDirectory: workingDirectory,
                environment: [:],
                outputHandling: .ignore
            )
            
            if runningResult.code == 0 {
                switch runningResult.stdout.trimmedUtf8String() {
                case CodeIsCompiled.yes.rawValue:
                    return .yes
                case CodeIsCompiled.no.rawValue:
                    return .no
                default:
                    throw "Unexpected output: \(runningResult.stdout)"
                }
            } else {
                throw "Unexpected status code: \(runningResult.code)"
            }
        }
    }
}

extension String {
    fileprivate func indent(level: Int = 1) -> String {
        let spaceCountPerLevel = 4
        let spaces = String(repeating: " ", count: level * spaceCountPerLevel)
        
        return replacingOccurrences(of: "\n", with: "\n\(spaces)")
    }
}
