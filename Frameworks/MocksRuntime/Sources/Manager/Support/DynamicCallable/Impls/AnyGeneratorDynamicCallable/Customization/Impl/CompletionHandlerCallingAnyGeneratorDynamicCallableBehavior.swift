import MixboxFoundation

/// Dynamic mock behavior that call completion handlers and only completion handlers.
///
/// Examples:
///
/// ```
/// // completion will be called with generated `Data`
/// func getData(completion: (Data) -> ())
///
/// // completion will be also called
/// func getData(completion: (Data) -> ()) -> Int
///
/// // it's ambiguous what to do, nothing will be done:
/// func getData(completion1: (Data) -> (), completion2: (Data) -> ()) -> Int
///
/// // not a completion handler, closure will not be called:
/// func getData(handleData: (Data) -> ()) -> Int
/// ```
///
public final class CompletionHandlerCallingAnyGeneratorDynamicCallableBehavior:
    AnyGeneratorDynamicCallableBehavior
{
    private let completionHandlerIndicatorSubstrings: Set<String> = ["completion"]
    private typealias CompletionClosureReturnType = Void
    
    public init() {
    }
    
    public func call<ReturnValue>(
        arguments: [AnyGeneratorDynamicCallableFunctionArgument],
        returnValueType: ReturnValue.Type)
        throws
        -> CustomizableScalar<ThrowingFunctionResult<ReturnValue>>
    {
        let allCompletionHandlers = arguments.compactMap { argument in
            argument.asClosure().flatMap {
                isCompletionHandler(closure: $0)
                    ? $0
                    : nil
            }
        }
        
        guard let completionHandler = allCompletionHandlers.mb_only else {
            if allCompletionHandlers.isEmpty {
                // No closures found, so no argument needs handling.
                // Something like `inout` arguments can be theoretically handled, however, this implementation
                // is about handling closures.
                return .automatic
            } else {
                let allCompletionHandlerArgumentNames = allCompletionHandlers
                    .map { $0.name ?? "_" }
                    .joined(separator: ", ")
                
                throw ErrorString(
                    """
                    Can generate behavior for function automatically, \
                    function contains multiple closures (named \(allCompletionHandlerArgumentNames) respectively),
                    which one is an indicator
                    """
                )
            }
        }
        
        // Return value is ignored, but error is not
        let value: ThrowingFunctionResult<CompletionClosureReturnType> = try completionHandler.call(
            arguments: .automatic
        )
        
        switch value {
        case .returnValue:
            return .automatic
        case let .error(error):
            return .customized(.error(error))
        }
    }
    
    private func isCompletionHandler(
        closure: AnyGeneratorDynamicCallableClosureArgument)
        -> Bool
    {
        let nameLooksLikeCompletionHandler = completionHandlerIndicatorSubstrings.contains { indicatorSubstring in
            [closure.name, closure.label].compactMap { $0 }.contains { string in
                string.lowercased().contains(
                    indicatorSubstring.lowercased()
                )
            }
        }
        
        return nameLooksLikeCompletionHandler
            && closure.returnValueType == CompletionClosureReturnType.self
    }
}
