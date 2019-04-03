import MixboxTestsFoundation

public extension ElementWithText {
    func text(
        file: StaticString = #file,
        line: UInt = #line)
        -> String
    {
        return value(valueTitle: "text") { snapshot -> String in
            (snapshot.text.value ?? "") ?? ""
        } ?? ""
    }
    
    func accessibilityLabel(
        file: StaticString = #file,
        line: UInt = #line)
        -> String
    {
        return value(valueTitle: "accessibilityLabel") { snapshot in
            snapshot.accessibilityLabel
        } ?? ""
    }
}
