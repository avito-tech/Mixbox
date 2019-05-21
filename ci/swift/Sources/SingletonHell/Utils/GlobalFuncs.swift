import Foundation
import Git
import Bash
import Simctl
import CiFoundation

public let bashExecutor = ProcessExecutorBashExecutor(
    processExecutor: LoggingProcessExecutor(
        originalProcessExecutor: FoundationProcessExecutor()
    ),
    environmentProvider: EnvironmentSingletons.environmentProvider
)

public func wrapError<T>(
    file: StaticString = #file,
    line: UInt = #line,
    body: () throws -> (T))
    rethrows
    -> T
{
    do {
        return try body()
    } catch {
        throw ErrorString("Error: \(error)", file: file, line: line)
    }
}

public func readJson<T: Codable>(fileName: String) throws -> T {
    let data = try wrapError {
        try Data(contentsOf: URL(fileURLWithPath: fileName))
    }
    
    return try wrapError {
        try JSONDecoder().decode(T.self, from: data)
    }
}

public func uuidgen() -> String {
    return UUID().uuidString
}

public func repoRoot() throws -> String {
    return try RepoRootProviderImpl().repoRootPath()
}

@discardableResult
public func bash(_ command: String) throws -> String {
    return try bashExecutor.executeAndReturnTrimmedOutputOrThrow(
        command: command
    )
}

@discardableResult
public func bash(command: String, currentDirectory: String) throws -> String {
    return try bashExecutor.executeAndReturnTrimmedOutputOrThrow(
        command: command,
        currentDirectory: currentDirectory
    )
}

public func rmrf(_ directory: String) throws {
    try bash(
        """
        rm -rf "\(directory)"
        """
    )
}

public func mkdirp(_ directory: String) throws {
    try bash(
        """
        mkdir -p "\(directory)"
        """
    )
}
