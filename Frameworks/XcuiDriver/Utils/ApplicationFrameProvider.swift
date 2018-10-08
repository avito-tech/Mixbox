import XCTest

// TODO: It is singleton. It is a cache without invalidation. It uses XCUIApplication().
// It is very bad, but saves some time in tests.
public final class ApplicationFrameProvider {
    public static let frame: CGRect = XCUIApplication().frame
}
