public protocol BundleResourcePathProvider: class {
    func path(resource: String) throws -> String
}
