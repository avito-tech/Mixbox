final class BaseActionTestCaseTests: BaseActionTestCase {
    func test_uiResetsProperly() {
        let text = "Some text"
        
        let actionSpecification = ActionSpecifications.setText(
            text: text
        )
        
        // Nothing is displayed initially
        screen.input(actionSpecification.elementId).withoutTimeout.assertIsNotDisplayed()
        screen.info.withoutTimeout.assertIsNotDisplayed()
        
        // ----
        
        // After setting views...
        setViews(
            showInfo: true,
            actionSpecifications: [actionSpecification]
        )
        
        // ...text is empty initially...
        screen.input(actionSpecification.elementId).assertHasText("")
        
        // ...also info is shown (showInfo: true)
        screen.info.assertIsDisplayed()
        
        // ----
        
        // After performing action...
        actionSpecification.performAction(screen: screen)
        
        // ...text is set
        screen.input(actionSpecification.elementId).assertHasText(text)
        
        // ----
        
        // But after this call...
        setViews(
            showInfo: false,
            actionSpecifications: [actionSpecification]
        )
        
        // ...text is empty again...
        screen.input(actionSpecification.elementId).assertHasText("")
        
        // ...also info is hidden (showInfo: false)
        screen.info.withoutTimeout.assertIsNotDisplayed()
    }
}
