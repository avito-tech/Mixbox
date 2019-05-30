import XCTest

// This class allows you to pass ability to access specific application.
// So it looks like passing instance of XCUIApplication.
// And passing instance of XCUIApplication leads to bugs.
//
// Note about creating instance of XCUIApplication:
//
// There are some moments (e.g.: setting up testcase dependencies)
// when constructing an application will fail test.
//
// Note about reusing instance of XCUIApplication:
//
// Accessing XCUIApplication by reference doesn't work as creating it.
// For example, when you create XCUIApplication snapshot caches are cleared properly.
// If you use it by reference, there will be problems with caches (snapshhot will
// not represent actual UI state).
//
// TODO: Rename to XcuiApplicationProvider
public protocol ApplicationProvider: class {
    var application: XCUIApplication { get }
}
