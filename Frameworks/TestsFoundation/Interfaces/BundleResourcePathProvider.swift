public protocol BundleResourcePathProvider {
    func path(resource: String) throws -> String
}
