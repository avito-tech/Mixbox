import Foundation
import CiFoundation

public final class XcodebuildResult {
    public let derivedDataPath: String
    public let products: String
    
    public init(derivedDataPath: String) {
        self.derivedDataPath = derivedDataPath
        self.products = NSString(string: "\(derivedDataPath)/Build/Products/Debug-iphonesimulator").standardizingPath
    }
    
    public func uiTestXctestBundlePath(testsTarget: String) throws -> String {
        try existingPath(
            path: try bundledInApplicationXctestBundlePath(
                appPath: try uiTestRunnerAppPath(testsTarget: testsTarget),
                testsTarget: testsTarget
            )
        )
    }
    
    public func standaloneXctestBundlePath(testsTarget: String) throws -> String {
        try existingPath(
            path: "\(products)/\(testsTarget).xctest"
        )
    }
    
    public func bundledInApplicationXctestBundlePath(appName: String, testsTarget: String) throws -> String {
        try existingPath(
            path: try bundledInApplicationXctestBundlePath(
                appPath: testedAppPath(appName: appName),
                testsTarget: testsTarget
            )
        )
    }
    
    public func bundledInApplicationXctestBundlePath(appPath: String, testsTarget: String) throws -> String {
        try existingPath(
            path: "\(appPath)/PlugIns/\(testsTarget).xctest"
        )
    }
    
    public func uiTestRunnerAppPath(testsTarget: String) throws -> String {
        try existingPath(
            path: "\(products)/\(testsTarget)-Runner.app"
        )
    }
    
    public func testedAppPath(appName: String) throws -> String {
        try existingPath(
            path: "\(products)/\(appName)"
        )
    }
    
    private func existingPath(path: String) throws -> String {
        if FileManager.default.fileExists(atPath: path) {
            return path
        } else {
            throw ErrorString("File doesn't exist at path: \(path)")
        }
    }
}
