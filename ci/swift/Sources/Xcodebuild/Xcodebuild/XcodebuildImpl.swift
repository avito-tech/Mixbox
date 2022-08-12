import Bash
import Foundation
import CiFoundation
import Cocoapods
import Git
import Destinations
import SingletonHell

public final class XcodebuildImpl: Xcodebuild {
    private let processExecutor: ProcessExecutor
    private let derivedDataPathProvider: DerivedDataPathProvider
    private let cocoapodsInstall: CocoapodsInstall
    private let repoRootProvider: RepoRootProvider
    private let environmentProvider: EnvironmentProvider
    private let ciLogger: CiLogger
    
    public init(
        processExecutor: ProcessExecutor,
        derivedDataPathProvider: DerivedDataPathProvider,
        cocoapodsInstall: CocoapodsInstall,
        repoRootProvider: RepoRootProvider,
        environmentProvider: EnvironmentProvider,
        ciLogger: CiLogger
    ) {
        self.processExecutor = processExecutor
        self.derivedDataPathProvider = derivedDataPathProvider
        self.cocoapodsInstall = cocoapodsInstall
        self.repoRootProvider = repoRootProvider
        self.environmentProvider = environmentProvider
        self.ciLogger = ciLogger
    }
    
    public func build(
        projectDirectoryFromRepoRoot: String,
        action: XcodebuildAction,
        workspaceName: String,
        scheme: String,
        sdk: String?,
        destination: String?)
        throws
        -> XcodebuildResult
    {
        try prepareForBuilding()
        
        let derivedDataPath = derivedDataPathProvider.derivedDataPath()
        let projectDirectory = try repoRootProvider.repoRootPath() + "/" + projectDirectoryFromRepoRoot
        
        print("Building using xcodebuild...")
        
        try? FileManager.default.removeItem(atPath: derivedDataPath)
        try FileManager.default.createDirectory(atPath: derivedDataPath, withIntermediateDirectories: true, attributes: nil)
        
        try cocoapodsInstall.install(
            projectDirectory: projectDirectory
        )
        
        let args = xcodebuildArgs(
            action: action,
            workspaceName: workspaceName,
            scheme: scheme,
            sdk: sdk,
            destination: destination,
            derivedDataPath: derivedDataPath
        )
        
        try ciLogger.logBlock(name: "Building \(workspaceName)->\(scheme)") {
            _ = try processExecutor.executeOrThrow(
                arguments: ["/usr/bin/xcodebuild"] + args,
                currentDirectory: projectDirectory,
                environment: environmentProvider.environment,
                outputHandling: .bypass
            )
        }
        
        return XcodebuildResult(derivedDataPath: derivedDataPath)
    }
    
    private func xcodebuildArgs(
        action: XcodebuildAction,
        workspaceName: String,
        scheme: String,
        sdk: String?,
        destination: String?,
        derivedDataPath: String)
        -> [String]
    {
        var args: [String] = [
            action.rawValue,
            "-workspace", "\(workspaceName).xcworkspace",
            "-scheme", scheme,
            "-derivedDataPath", derivedDataPath
        ]
        
        if let sdk = sdk {
            args.append(contentsOf: ["-sdk", sdk])
        }
        
        if let destination = destination {
            args.append(contentsOf: ["-destination", destination])
        }
        
        return args
    }
    
    private func prepareForBuilding() throws {
        try FileManager.default.createDirectory(
            atPath: try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_REPORTS_PATH),
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}
