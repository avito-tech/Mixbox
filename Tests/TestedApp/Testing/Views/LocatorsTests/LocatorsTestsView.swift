import UIKit
import MixboxTestability

final class LocatorsTestsView: TestStackScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addLabel(id: "label_exists") {
            $0.text = "label_exists"
        }
        
        addLabel(id: "one_of_two_labels_one_is_hidden") {
            $0.text = "one_of_two_labels_one_is_hidden"
        }
        addLabel(id: "one_of_two_labels_one_is_hidden") {
            $0.text = "one_of_two_labels_one_is_hidden"
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
            $0.text = "one_of_labels_with_custom_values"
            $0.testability_customValues["string"] = "the string"
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            $0.text = "one_of_labels_with_custom_values"
            $0.testability_customValues["bool_false"] = false
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            $0.text = "one_of_labels_with_custom_values"
            $0.testability_customValues["bool_true"] = true
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            $0.text = "one_of_labels_with_custom_values"
            $0.testability_customValues["int_0"] = 0
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            $0.text = "one_of_labels_with_custom_values"
            $0.testability_customValues["int_1"] = 1
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            $0.text = "one_of_labels_with_custom_values"
            $0.testability_customValues["int_-1"] = -1
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            $0.text = "one_of_labels_with_custom_values"
            $0.testability_customValues["double_0"] = Double(0)
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            $0.text = "one_of_labels_with_custom_values"
            $0.testability_customValues["double_inf"] = Double.infinity
        }
        addLabel(id: "one_of_labels_with_custom_values") {
            $0.text = "one_of_labels_with_custom_values"
            $0.testability_customValues["double_nan"] = Double.nan
        }
        
        // TODO: test mathing text, startsWith/endsWith/contains/etc
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
