// TODO: This interface should not exists. We should have ability to access every UI element from every action.
//
// It is a temporary workaround to pause current refactoring.
// Should be refactored further during implementation of Gray Box tests.

// See also: MenuItemProvider
public protocol MenuItem {
    func tap()
    func waitForExistence(timeout: TimeInterval) -> Bool
}

extension MenuItem {
    public func waitForExistence() -> Bool {
        return waitForExistence(timeout: 5)
    }
}
