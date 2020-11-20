import SourceryFramework
import SourceryRuntime

extension TypeName {
    // Returns string representing a type that is a valid Swift type.
    //
    // Sourcery doesn't provide a type name that is a Swift type.
    // E.g.: `name` can return `inout @autoclosure () -> Int`, but the type is `() -> Int`.
    // Sourcery has `unwrappedTypeName`, which removes annotations, but it also removes optionality for whatever reason.
    public var validTypeName: String {
        var name = self.name
        
        name = name.removing(attributes: attributes)
        name = name.removingGenericConstraints()
        name = name.bracketsBalancing()
        name = name.trimmingPrefix("inout ").trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.isEmpty {
            return "()"
        } else {
            return name
        }
    }
}

extension String {
    fileprivate func removing(attributes:  [String: Attribute]) -> String {
        var typeName = self
        
        attributes.forEach {
            typeName = typeName.replacingOccurrences(
                of: $0.value.description,
                with: ""
            )
                
        }
        return typeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    fileprivate func removingGenericConstraints() -> String {
        if let genericConstraint = self.range(of: "where") {
            return String(self.prefix(upTo: genericConstraint.lowerBound))
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return self
        }
    }
}
