import MixboxUiTestsFoundation

final class PermissionsTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    let viewName = "PermissionsTestsView"
    
    func permission<Spec: ApplicationPermissionSpecification>(_ specification: Spec) -> LabelElement {
        return byId(specification.identifier)
    }
}
