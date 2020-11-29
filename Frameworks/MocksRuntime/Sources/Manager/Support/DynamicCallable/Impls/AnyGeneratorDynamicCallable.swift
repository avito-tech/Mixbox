import MixboxFoundation
import MixboxGenerators

public final class AnyGeneratorDynamicCallable: DynamicCallable {
    private let anyGenerator: AnyGenerator
    
    public init(anyGenerator: AnyGenerator) {
        self.anyGenerator = anyGenerator
    }
    
    public func call<ReturnValue>(
        recordedCallArguments: RecordedCallArguments,
        returnValueType: ReturnValue.Type)
        -> DynamicCallableResult<ReturnValue>
    {
        do {
            // Example. Imagine this function:
            //
            // ```
            // func getData(completion: (Data) -> ())
            // ```
            //
            // It is highly unlikely that just returning Void will be a good behavior by default.
            // It can lead to unexpected results and hanging tests.
            //
            let hasEscapingClosures = recordedCallArguments.arguments.contains { (argument) -> Bool in
                switch argument {
                case .escapingClosure, .optionalEscapingClosure:
                    return true
                case .nonEscapingClosure, .regular:
                    return false
                }
            }
            
            if hasEscapingClosures {
                return .canNotProvideResult(
                    ErrorString(
                        """
                        Currently dynamic implementations of functions with escaping closures are not supported
                        """
                    )
                )
            } else {
                return .returned(try anyGenerator.generate())
            }
        } catch {
            return .canNotProvideResult(error)
        }
    }
}
