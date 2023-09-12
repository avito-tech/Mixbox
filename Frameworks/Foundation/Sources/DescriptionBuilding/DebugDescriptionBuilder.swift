#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class DebugDescriptionBuilder: CustomDebugStringConvertible {
    private static var indentation: String { "    " }
    private static var descriptionOfNil: String { "nil" }
    private static var doubledIndentation: String { String(repeating: indentation, count: 2) }
    
    private let name: String
    
    // Fields as in a result string, with indentation, name, value
    private var fields = [String]()
    
    // MARK: - Init
    
    public init(name: String) {
        self.name = name
    }
    
    public convenience init(type: Any.Type) {
        self.init(name: "\(type)")
    }
    
    public convenience init(typeOf: Any) {
        self.init(type: type(of: typeOf))
    }
    
    // MARK: - Adding fields
    
    public func add<T>(
        name: String,
        value: T?)
        -> DebugDescriptionBuilder
    {
        return add(
            name: name,
            debugDescription: value.flatMap(description) ?? DebugDescriptionBuilder.descriptionOfNil
        )
    }
    
    public func add<T>(
        name: String,
        array: [T]?)
        -> DebugDescriptionBuilder
    {
        let debugDescription: String
        
        if let array = array {
            debugDescription = array
                .map { description($0) }
                .joined(separator: ",\n")
                .mb_wrapAndIndent(
                    indentation: DebugDescriptionBuilder.doubledIndentation, // additional indentation for array
                    prefix: "[",
                    postfix: "\(DebugDescriptionBuilder.indentation)]",
                    ifEmpty: "[]"
                )
        } else {
            debugDescription = DebugDescriptionBuilder.descriptionOfNil
        }
        
        return add(
            name: name,
            debugDescription: debugDescription
        )
    }
    
    public func add<T, U>(
        name: String,
        dictionary: [T: U]?)
        -> DebugDescriptionBuilder
    {
        let debugDescription: String
        
        if let dictionary = dictionary {
            debugDescription = dictionary
                .map { "\(description($0)): \(description($1))" }
                .joined(separator: ",\n")
                .mb_wrapAndIndent(
                    indentation: DebugDescriptionBuilder.doubledIndentation, // additional indentation for dictionary
                    prefix: "[",
                    postfix: "\(DebugDescriptionBuilder.indentation)]",
                    ifEmpty: "[]"
                )
        } else {
            debugDescription = DebugDescriptionBuilder.descriptionOfNil
        }
        
        return add(
            name: name,
            debugDescription: debugDescription
        )
    }
    
    private func description<T>(_ value: T) -> String {
        return (value as? CustomDebugStringConvertible)?.debugDescription ?? String(describing: "\(value)")
    }
    
    public func add(
        name: String,
        debugDescription: String)
        -> DebugDescriptionBuilder
    {
        fields.append(
            "\(DebugDescriptionBuilder.indentation)\(name): \(debugDescription)"
        )
        
        return self
    }
    
    // MARK: - CustomDebugStringConvertible
    
    public var debugDescription: String {
        if fields.isEmpty {
            return "\(name)()"
        } else {
            let fieldsDescription = fields.joined(separator: ",\n")
            
            return """
            \(name)(
            \(fieldsDescription)
            )
            """
        }
    }
}

extension DebugDescriptionBuilder {
    public func add(
        name: String,
        value: Bool)
        -> DebugDescriptionBuilder
    {
        return add(name: name, value: value ? "true" : "false")
    }
}

#endif
