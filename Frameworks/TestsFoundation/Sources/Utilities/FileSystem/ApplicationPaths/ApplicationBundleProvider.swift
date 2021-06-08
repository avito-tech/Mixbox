public protocol ApplicationBundleProvider: AnyObject {
    // Throws ErrorString
    func applicationBundle() throws -> Bundle
}
