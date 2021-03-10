import MixboxUiTestsFoundation

public final class XcuiApplicationFrameProvider: ApplicationFrameProvider {
    // NOTE: There may be (i am sure) bugs with rotation or with changing application frame on iPad.
    // Note that caching of `frame` is very helpful!
    public lazy var applicationFrame: CGRect = applicationProvider.application.frame
    private let applicationProvider: ApplicationProvider
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider = applicationProvider
    }
}
