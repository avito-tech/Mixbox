import Foundation

public protocol ApplicationBundleProvider: class {
    // Throws ErrorString
    func applicationBundle() throws -> Bundle
}
