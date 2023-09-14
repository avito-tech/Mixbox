import MixboxTestsFoundation

public final class IsInstanceElementSnapshotMatcher: Matcher<ElementSnapshot> {
    public init(_ className: String) {
        super.init(
            description: {
                "is instance of \(className)"
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
                                actualResult = "unknown"
                            default:
                                actualResult = alternatives.joined(separator: " or ")
                            }
                    
                            return "is not instance of \(className), actual values: \(actualResult)"
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
}
