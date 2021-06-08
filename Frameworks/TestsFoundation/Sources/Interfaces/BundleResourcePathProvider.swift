public protocol BundleResourcePathProvider: AnyObject {
    func path(resource: String) throws -> String
}
