import MixboxFoundation
import XCTest

public final class BuiltApplicationBundleProvider: ApplicationBundleProvider {
    private let application: XCUIApplication
    
    public init(application: XCUIApplication) {
        self.application = application
    }
    
    public func applicationBundle() throws -> Bundle {
        fatalError()
//        guard let path = application.path else {
//            throw ErrorString("application.path is nil, application: \(application)")
//        }
//
//        guard let bundle = Bundle(path: path) else {
//            throw ErrorString("File at path \(path) is not a bundle")
//        }
//
//        return bundle
    }
}
