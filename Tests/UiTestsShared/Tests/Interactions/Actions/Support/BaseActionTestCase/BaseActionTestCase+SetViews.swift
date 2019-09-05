import XCTest
import MixboxUiTestsFoundation
import TestsIpc

extension BaseActionTestCase {
    func setViews(
        showInfo: Bool,
        actionSpecifications: [AnyActionSpecification])
    {
        setViews(
            ui: ActionsTestsViewModel(
                showInfo: showInfo,
                viewNames: actionSpecifications.map { $0.elementId },
                alpha: 1,
                isHidden: false,
                overlapping: 0,
                touchesAreBlocked: false
            )
        )
    }
    
    func setViews(
        ui: ActionsTestsViewModel)
    {
        XCTAssert(ui.touchesAreBlocked == false, "touchesAreBlocked==true is not implemented")
        
        let error = ipcClient.callOrFail(
            method: SetViewsIpcMethod(),
            arguments: ui
        )
        
        if let error = error {
            XCTFail(error.value)
        }
    }
}
