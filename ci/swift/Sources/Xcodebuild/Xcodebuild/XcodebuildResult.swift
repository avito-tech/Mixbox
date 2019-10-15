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
        return try existingPath(
            path: try xctestBundlePath(
                appPath: try uiTestRunnerAppPath(testsTarget: testsTarget),
                testsTarget: testsTarget
            )
        )
    }
    
    public func unitTestXctestBundlePath(appName: String, testsTarget: String) throws -> String {
        return try existingPath(
            path: try xctestBundlePath(
                appPath: testedAppPath(appName: appName),
                testsTarget: testsTarget
            )
        )
    }
    
    public func xctestBundlePath(appPath: String, testsTarget: String) throws -> String {
        return try existingPath(
            path: "\(appPath)/PlugIns/\(testsTarget).xctest"
        )
    }
    
    public func uiTestRunnerAppPath(testsTarget: String) throws -> String {
        return try existingPath(
            path: "\(products)/\(testsTarget)-Runner.app"
        )
    }
    
    public func testedAppPath(appName: String) throws -> String {
        return try existingPath(
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
