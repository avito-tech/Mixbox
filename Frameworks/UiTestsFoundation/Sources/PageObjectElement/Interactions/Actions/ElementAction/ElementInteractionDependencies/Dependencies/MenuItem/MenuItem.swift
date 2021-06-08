import Foundation

// TODO: This interface should not exists. We should have ability to access every UI element from every action.
//
// It is a temporary workaround to pause current refactoring.
// Should be refactored further during implementation of Gray Box tests.

// See also: MenuItemProvider
public protocol MenuItem: AnyObject {
    func tap() throws
    func waitForExistence(timeout: TimeInterval) throws
}

extension MenuItem {
    public func waitForExistence() throws {
        return try waitForExistence(timeout: 5)
    }
}
