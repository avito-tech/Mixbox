import XCTest
import TestsIpc

final class InteractionsUseVisiblePointTests: TestCase {
    private var screen: InteractionsUseVisiblePointTestsViewPageObject {
        return pageObjects.interactionsUseVisiblePointTestsViewPageObject.default
    }
    
    private var button: TapIndicatorButtonElement {
        return screen.button.with(percentageOfVisibleArea: 0.01)
    }
    
    override func precondition() {
        super.precondition()
        
        open(screen: pageObjects.interactionsUseVisiblePointTestsViewPageObject)
            .waitUntilViewIsLoaded()
    }
    
    // Idea: Overlap most of the button.
    // Visibility checking algorithm should provide a visible point closest to center
    // Tap should only tap visible points.
    //
    // +-----+   +-----+   +-----+   +-----+
    // |     |   |  XXX|   |XXXXX|   |XXX  |
    // |XXXXX|   |  XXX|   |XXXXX|   |XXX  |
    // |XXXXX|   |  XXX|   |     |   |XXX  |
    // +-----+   +-----+   +-----+   +-----+
    //
    // TODO: Check if point is closest to center
    func test___tap___taps_visible_point() {
        resetUi(insets: 200, 0, 0, 0)
        checkButton()
        
        resetUi(insets: 0, 100, 0, 0)
        checkButton()
        
        resetUi(insets: 0, 0, 200, 0)
        checkButton()
        
        resetUi(insets: 0, 0, 0, 100)
        checkButton()
    }
    
    private func checkButton() {
        button.assert(isTapped: false)
        button.tap()
        button.assert(isTapped: true)
    }
    
    func resetUi(insets top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        let bounds = mainScreenBounds()
        
        resetUi(
            argument: InteractionsUseVisiblePointTestsViewConfiguration(
                buttonFrame: bounds,
                overlappingViewFrame: bounds.mb_shrinked(
                    top: top, left: left, bottom: bottom, right: right
                )
            )
        )
    }
}
