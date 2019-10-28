public final class IsInstanceMatcher: Matcher<ElementSnapshot> {
    public init(_ className: String) {
        super.init(
            description: {
                "является инстансом класса \(className)"
            },
            matchingFunction: { snapshot in
                let uikitClass = snapshot.uikitClass
                let customClass = snapshot.customClass
                
                if className == uikitClass || className == customClass {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            let actualResult: String
                            let alternatives = [uikitClass, customClass].compactMap { $0 }.map { "\"" + $0 + "\"" }
                    
                            switch alternatives.count {
                            case 0:
                                actualResult = "неизвестно"
                            default:
                                actualResult = alternatives.joined(separator: " или ")
                            }
                    
                            return "не является инстансом класса \(className), актуальные значения: \(actualResult)"
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
