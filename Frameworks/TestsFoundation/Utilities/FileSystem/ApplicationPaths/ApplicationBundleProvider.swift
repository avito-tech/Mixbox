public protocol ApplicationBundleProvider {
    // Throws ErrorString
    func applicationBundle() throws -> Bundle
}
