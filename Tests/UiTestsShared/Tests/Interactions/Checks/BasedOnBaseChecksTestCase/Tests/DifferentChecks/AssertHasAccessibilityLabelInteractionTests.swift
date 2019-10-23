import MixboxUiTestsFoundation

final class AssertHasAccessibilityLabelInteractionTests: BaseChecksTestCase {
    func test___assertHasAccessibilityLabel___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___assertHasAccessibilityLabel___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    func test___assertHasAccessibilityLabel___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.hasLabel0 },
            assert: { $0.assertHasAccessibilityLabel("Accessibility Label") }
        )
    }
    
    func test___assertHasAccessibilityLabel___passes___if_text_is_set_instead_of_accessibilityLabel() {
        check___assert_passes_immediately___if_ui_appears_immediately(
            AssertSpecification(
                element: { screen in screen.hasLabel1 },
                assert: { $0.assertHasAccessibilityLabel("Text That Is Expected In Accessibility Label") }
            )
        )
    }
    
    func test___assertHasAccessibilityLabel___passes___if_view_is_UIButton() {
        check___assert_passes_immediately___if_ui_appears_immediately(
            AssertSpecification(
                element: { screen in screen.hasLabel2 },
                assert: { $0.assertHasAccessibilityLabel("Accessibility Label") }
            )
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertHasAccessibilityValue___failsProperlyIfAccessibilityValueMismatches() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что в "hasLabel0" accessibilityLabel равен "Accessibility [check shall not pass] Label"" неуспешно, так как: проверка неуспешна (Имеет проперти label: равно Accessibility [check shall not pass] Label): не равно 'Accessibility [check shall not pass] Label', актуальное значение: 'Accessibility Label')
                """,
            body: {
                screen.hasLabel0
                    .withoutTimeout
                    .assertHasAccessibilityLabel("Accessibility [check shall not pass] Label")
            }
        )
    }
}
