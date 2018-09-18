import XCTest

// TODO: It is singleton. It is a cache without invalidation. It uses XCUIApplication().
// It is very bad, but saves some time in tests.
final class ApplicationFrameProvider {
    static let frame: CGRect = XCUIApplication().frame
}
