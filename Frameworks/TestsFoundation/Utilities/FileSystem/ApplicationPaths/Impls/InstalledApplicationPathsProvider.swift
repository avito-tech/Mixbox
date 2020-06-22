import XCTest
import MixboxFoundation
import MixboxTestsFoundation_objc

public final class InstalledApplicationBundleProvider: ApplicationBundleProvider {
    private let application: XCUIApplication
    private let currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider
    
    public init(
        application: XCUIApplication,
        currentSimulatorFileSystemRootProvider: CurrentSimulatorFileSystemRootProvider)
    {
        self.application = application
        self.currentSimulatorFileSystemRootProvider = currentSimulatorFileSystemRootProvider
    }
    
    public func applicationBundle() throws -> Bundle {
        guard let bundleId = application.bundleID else {
            throw ErrorString("Failed to get bundle id of application \(application)")
        }
        
        let path = try bundlePath(
            installedAppContainers: try installedAppContainers(
                installedAppContainersDirectory: try installedAppContainersDirectory()
            ),
            applicationFileName: applicationFileName(
                sourceApplicationPath: try sourceApplicationPath()
            ),
            bundleId: bundleId
        )
        
        guard let bundle = Bundle(path: path) else {
            throw ErrorString("File at path \(path) is not a bundle")
        }
        
        return bundle
    }
    
    private func bundlePath(
        installedAppContainers: [String],
        applicationFileName: String,
        bundleId: String)
        throws -> String
    {
        for installedAppContainer in installedAppContainers {
            let expectedBundlePath = installedAppContainer
                .mb_appendingPathComponent(applicationFileName)
            
            if FileManager.default.fileExists(atPath: expectedBundlePath) {
                let infoPlist = NSDictionary(
                    contentsOfFile: expectedBundlePath.mb_appendingPathComponent("Info.plist")
                )
                let bundleIdFromFile = (infoPlist?["CFBundleIdentifier"].flatMap { $0 as? String })
                
                if bundleIdFromFile == bundleId {
                    return expectedBundlePath
                }
            }
        }
        
        throw ErrorString("Application \(applicationFileName) was not found")
    }
    
    private func sourceApplicationPath() throws -> String {
        guard let path = application.path else {
            throw ErrorString("application.path is nil, application: \(application)")
        }
        
        return path
    }
    
    private func applicationFileName(sourceApplicationPath: String) -> String {
        return (sourceApplicationPath as NSString).lastPathComponent
    }
    
    private func installedAppContainersDirectory() throws -> String {
        let root = try currentSimulatorFileSystemRootProvider.currentSimulatorFileSystemRoot()
        
        return root.osxPath("/data/Containers/Bundle/Application/")
    }
    
    private func installedAppContainers(installedAppContainersDirectory: String) throws -> [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: installedAppContainersDirectory)
                .map { installedAppContainersDirectory.mb_appendingPathComponent($0) }
        } catch {
            throw ErrorString("Failed to get installed application containers in \(installedAppContainersDirectory): \(error)")
        }
    }
}
