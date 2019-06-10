import MixboxUiTestsFoundation
import XCTest
import TestsIpc

final class FakeCellsDisablingTests: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    func test___fake_cells_can_be_disabled() {
        performTest(enableFakeCells: false)
    }
    
    func test___fake_cells_can_be_enabled_back() {
        performTest(enableFakeCells: true)
    }
    
    private func performTest(enableFakeCells: Bool) {
        openScreen(
            name: "FakeCellsTestsView",
            additionalEnvironment: ["MIXBOX_SHOULD_ENABLE_FAKE_CELLS": enableFakeCells ? "true" : "false" ]
        )
        
        guard let last = allElementIds.last else {
            XCTFail("You should have enough cells for some of them to be offscreen. This test needs such cells to pass")
            return
        }
        
        let lastElement = pageObjects.screen.element(id: last, set: lastSetId)
        
        if enableFakeCells {
            // Fake cells do work, so element beneath the screen is visible for Mixbox ( but not for simple users).
            lastElement.assertIsDisplayed()
        } else {
            // Fake cells do not work, so element beneath the screen is not visible (neigther for Mixbox, nor for users).
            lastElement.assertIsNotDisplayed()
        }
    }
}

private extension PageObjects {
    var screen: ScreenForFakeCellsTesting {
        return pageObject()
    }
}
