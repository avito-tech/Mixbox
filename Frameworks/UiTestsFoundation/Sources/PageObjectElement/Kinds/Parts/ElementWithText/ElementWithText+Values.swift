import MixboxTestsFoundation

public extension ElementWithText {
    func text(
        file: StaticString = #file,
        line: UInt = #line)
        -> String
    {
        return value(file: file, line: line, valueTitle: "text") { snapshot -> String in
            (snapshot.text.valueIfAvailable ?? "") ?? ""
        } ?? ""
    }
    
    func accessibilityLabel(
        file: StaticString = #file,
        line: UInt = #line)
        -> String
    {
        return value(file: file, line: line, valueTitle: "accessibilityLabel") { snapshot in
            snapshot.accessibilityLabel
        } ?? ""
    }
}
