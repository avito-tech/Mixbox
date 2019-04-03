import MixboxUiTestsFoundation

// TODO:
//
// 1. Share most of the code with XcuiPageObjectElementActions.
// 2. Remove XcuiPageObjectElementActions and GreyPageObjectElementActions, use shared class.
// (like GreyPageObjectElemenChecks and GreyPageObjectElemenActions became PageObjectElementChecksImpl)
//
public final class GreyPageObjectElementActions: PageObjectElementActions {
    private let elementSettings: ElementSettings
    
    public init(
        elementSettings: ElementSettings)
    {
        self.elementSettings = elementSettings
    }
}
