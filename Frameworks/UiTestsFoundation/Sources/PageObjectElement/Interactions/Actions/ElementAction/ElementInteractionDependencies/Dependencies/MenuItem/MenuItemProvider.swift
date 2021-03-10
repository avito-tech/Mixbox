// TODO: This interface should not exists. We should have ability to access every UI element from every action.
//
// It is a temporary workaround to pause current refactoring.
// Should be refactored further during implementation of Gray Box tests.
//
// See also: MenuItem
public protocol MenuItemProvider: class {
    func menuItem(possibleTitles: [String]) -> MenuItem
}
