import MixboxFoundation

public final class BundleResourcePathProviderImpl: BundleResourcePathProvider {
    private let bundle: Bundle
    
    public init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    public func path(resource: String) throws -> String {
        guard let path = bundle.path(forResource: resource, ofType: nil) else {
            throw ErrorString(
                """
                Bundle "\(bundle)" doesn't contain resource named "\(resource)"
                """
            )
        }
        
        return path
    }
}
