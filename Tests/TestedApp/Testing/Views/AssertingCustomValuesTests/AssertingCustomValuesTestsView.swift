import UIKit
import MixboxTestability

final class AssertingCustomValuesTestsView: TestStackScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        add("string", "the string")
        add("bool_false", false)
        add("bool_true", true)
        add("int_0", 0)
        add("int_1", 1)
        add("int_-1", -1)
        add("double_0", Double(0))
        add("double_inf", Double.infinity)
        add("double_nan", Double.nan)
        
        add("double_1.0", Double(1.0))
        
        // TODO: test mathing text, startsWith/endsWith/contains/etc
    }
    
    private func add<T: Codable>(_ id: String, _ value: T) {
        addLabel(id: id) {
            $0.text = id
            $0.testability_customValues["valueKey"] = value
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
