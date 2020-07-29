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
    
    // TODO: Fix case with overlapping. This test will be helpful in debugging:
    //
    // func test() {
    //     resetUi(
    //         buttonSide: 3,
    //         buttonOffset: 0,  // it is not necessary in this test
    //         layout: .vertical,
    //         overlapped: true
    //     )
    //     checkButton()
    // }
    //
    func test___tap___taps_buttons_with_size_of_few_points() {
        for overlapped in [false/*, true */] {
            for layout in ButtonLayout.allCases {
                for buttonSide in [4, 3, 2, 1] as [CGFloat] {
                    resetUi(
                        buttonSide: buttonSide,
                        buttonOffset: 0,  // it is not necessary in this test
                        layout: layout,
                        overlapped: overlapped
                    )
                    assertPasses(
                        message: { failures in
                            """
                            Test failed on this data set: \
                            buttonSide: \(buttonSide) \
                            layout: \(layout) \
                            overlapped: \(overlapped) \
                            Failures: \(failures)
                            """
                        },
                        body: {
                            checkButton()
                        }
                    )
                }
            }
        }
    }
    
    // TODO: private
    enum ButtonLayout: CaseIterable {
        case vertical
        case horizontal
    }
    
    // TODO: private
    func checkButton() {
        button.withoutTimeout.assert(isTapped: false)
        button.withoutTimeout.tap()
        button.withoutTimeout.assert(isTapped: true)
    }
    
    // TODO: private
    func resetUi(
        fractionOfPoint: Int,
        offsetInFractionsOfPoint: Int,
        layout: ButtonLayout,
        overlapped: Bool)
    {
        let buttonSide = 1 / CGFloat(fractionOfPoint)
        let buttonOffset = buttonSide * CGFloat(offsetInFractionsOfPoint)
        
        resetUi(
            buttonSide: buttonSide,
            buttonOffset: buttonOffset,
            layout: layout,
            overlapped: overlapped
        )
    }
    
    private func resetUi(
        buttonSide: CGFloat,
        buttonOffset: CGFloat,
        layout: ButtonLayout,
        overlapped: Bool)
    {
        let bounds = mainScreenBounds()
        
        // A square, centered on screen, half of the size of screen
        let overlappingViewSide = min(bounds.width, bounds.height) / 2
        var overlappingViewFrame = CGRect(
            origin: .zero,
            size: CGSize(
                width: overlappingViewSide,
                height: overlappingViewSide
            )
        )
        overlappingViewFrame.mb_center = bounds.mb_center
        
        let buttonFrame: CGRect
        
        switch layout {
        case .vertical:
            buttonFrame = CGRect(
                x: bounds.mb_centerX + buttonOffset,
                y: 0,
                width: buttonSide,
                height: bounds.height
            )
        case .horizontal:
            buttonFrame = CGRect(
                x: 0,
                y: bounds.mb_centerY + buttonOffset,
                width: bounds.width,
                height: buttonSide
            )
        }
        
        resetUi(
            argument: InteractionsUseVisiblePointTestsViewConfiguration(
                buttonFrame: buttonFrame,
                overlappingViewFrame: overlapped ? overlappingViewFrame : .zero
            )
        )
    }
    
    private func resetUi(insets top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
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
