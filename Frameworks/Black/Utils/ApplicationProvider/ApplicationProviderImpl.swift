import XCTest

public final class ApplicationProviderImpl: ApplicationProvider {
    private let closure: () -> XCUIApplication
    
    public init(closure: @escaping () -> XCUIApplication) {
        self.closure = closure
    }
    
    public var application: XCUIApplication {
        return closure()
    }
}
