import Foundation

public final class IsSameInstanceMatcher<T>: Matcher<T> {
    private init(_ otherValue: T, _ areEqual: @escaping (T, T) -> Bool) {
        super.init(
            description: {
                "is same instance as \(otherValue)"
            },
            matchingFunction: { actualValue in
                if areEqual(actualValue, otherValue) {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: {
                            """
                            value is not same instance as '\(otherValue)', \
                            actual value: '\(actualValue)')
                            """
                        },
                        attachments: { [] }
                    )
                }
            }
        )
    }
    
    public convenience init(_ otherValue: T) where T: AnyObject {
        self.init(otherValue, ===)
    }
    
    public convenience init(_ otherValue: T) where T == AnyObject.Type {
        self.init(otherValue, ===)
    }
    
    public convenience init(_ otherValue: T) where T == NSObject.Type {
        self.init(otherValue, ===)
    }
}
