import MixboxTestsFoundation

public final class ClosureArgumentValueReflection {
    public let argumentTypes: [Any.Type]
    public let returnValueType: Any.Type
    
    private let callImplementation: (Arguments) throws -> Any

    public final class Arguments {
        public var arguments: [Any]
        
        public init(_ arguments: [Any]) {
            self.arguments = arguments
        }
        
        public subscript<T>(_ index: Int) -> T {
            get {
                guard let untypedElement = arguments.mb_elementAtIndex(index) else {
                    UnavoidableFailure.fail(
                        """
                        Internal error: attempted to get argument at index \(index) an pass it to closure \
                        but closure supports only supports \(arguments.count) number of arguments
                        """
                    )
                }
                
                guard let typedElement = untypedElement as? T else {
                    UnavoidableFailure.fail(
                        """
                        Internal error: attempted to get argument at index \(index) an pass it to closure
                        but closure expects to receive argument of type \(T.self) and the argument that
                        is retrieved from array of arguments has type \(type(of: untypedElement)).
                        """
                    )
                }
                
                return typedElement
            }
            set {
                if (0..<arguments.count).contains(index) {
                    arguments[index] = newValue
                } else {
                    UnavoidableFailure.fail(
                        """
                        Internal error: attempted to set argument at index \(index), but maximum number of \
                        arguments is \(arguments.count)
                        """
                    )
                }
            }
        }
    }
    
    public init(
        argumentTypes: [Any.Type],
        returnValueType: Any.Type,
        callImplementation: @escaping (Arguments) throws -> Any)
    {
        self.argumentTypes = argumentTypes
        self.returnValueType = returnValueType
        self.callImplementation = callImplementation
    }
    
    public func call<ReturnValue>(
        arguments: [Any])
        throws
        -> ThrowingFunctionResult<ReturnValue>
    {
        let untypedResult = callAndReturnUntypedResult(arguments: arguments)
        
        return try untypedResult.mapReturnValue { untypedResult in
            do {
                return try (untypedResult as? ReturnValue).unwrapOrThrow(
                    message:
                    """
                    Internal error: `ClosureReflection.callImplementation` returned value that is not of expected \
                    `ReturnValue` type. Expected type: \(ReturnValue.self). Actual type: \(untypedResult)."
                    """
                )
            } catch {
                throw error
            }
        }
    }
        
    private func callAndReturnUntypedResult(
        arguments: [Any])
        -> ThrowingFunctionResult<Any>
    {
        do {
            let untypedResult = try callImplementation(Arguments(arguments))
        
            return .returnValue(untypedResult)
        } catch {
            return .error(error)
        }
    }
}
