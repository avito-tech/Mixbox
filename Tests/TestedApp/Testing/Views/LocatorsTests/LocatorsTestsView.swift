import UIKit
import MixboxTestability

final class LocatorsTestsView: TestStackScrollView {
    // swiftlint:disable:next function_body_length
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addLabel(id: "label_that_exists") {
            setDefaultText($0)
        }
        
        addLabel(id: "label_with_accessibilityValue") {
            setDefaultText($0)
            $0.accessibilityValue = "label_with_accessibilityValue_accessibilityValue"
        }
        
        addLabel(id: "label_with_accessibilityLabel") {
            setDefaultText($0)
            $0.accessibilityLabel = "label_with_accessibilityLabel_accessibilityLabel"
        }
        
        addLabel(id: "one_of_two_labels_one_is_hidden") {
            setDefaultText($0)
        }
        addLabel(id: "one_of_two_labels_one_is_hidden") {
            setDefaultText($0)
            $0.isHidden = true
        }
        
        addLabel(id: "one_of_two_labels_one_with_custom_value") {
            $0.text = "one_of_two_labels_one_with_custom_value (with custom value)"
            $0.testability_customValues["hasCustomValue"] = true
        }
        addLabel(id: "one_of_two_labels_one_with_custom_value") {
            $0.text = "one_of_two_labels_one_with_custom_value (without custom value)"
        }
        
        addLabel(id: "one_of_labels_with_custom_values") {
            setDefaultText($0)
            $0.testability_customValues["string"] = "the string"
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            setDefaultText($0)
            $0.testability_customValues["bool_false"] = false
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            setDefaultText($0)
            $0.testability_customValues["bool_true"] = true
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            setDefaultText($0)
            $0.testability_customValues["int_0"] = 0
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            setDefaultText($0)
            $0.testability_customValues["int_1"] = 1
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            setDefaultText($0)
            $0.testability_customValues["int_-1"] = -1
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            $0.testability_customValues["double_0"] = Double(0)
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            setDefaultText($0)
            $0.testability_customValues["double_inf"] = Double.infinity
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            setDefaultText($0)
            $0.testability_customValues["double_nan"] = Double.nan
        }
        
        // TODO: test mathing text, startsWith/endsWith/contains/etc
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDefaultText(_ label: UILabel) {
        // TODO: Assertion failure
        if let id = label.accessibilityIdentifier {
            label.text = "\(id)_text"
        } else {
            print("Assertion failure")
        }
    }
}
