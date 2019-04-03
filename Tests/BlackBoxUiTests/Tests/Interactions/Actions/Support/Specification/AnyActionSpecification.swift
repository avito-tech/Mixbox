import MixboxUiTestsFoundation

protocol AnyActionSpecification {
    var elementId: String { get }
    var expectedResult: String { get }
    
    func performAction(screen: ActionsTestsScreen)
}
