import MixboxUiTestsFoundation

public final class XcuiTextTyper: TextTyper {
    private let applicationProvider: ApplicationProvider
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider = applicationProvider
    }
    
    public var keys: TextTyperKeys {
        return XcuiTextTyperKeys()
    }
    
    public func type(text: String) {
        applicationProvider.application.typeText(text)
    }
}
