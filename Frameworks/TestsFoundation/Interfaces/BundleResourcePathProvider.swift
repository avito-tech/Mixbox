public protocol BundleResourcePathProvider: class {
    func path(resource: String) throws -> String
}

// Provides bundle for tests bundle.
// Marker protocol, to be used in DI.
public protocol BundleResourcePathProviderForTestsTarget: BundleResourcePathProvider {}
