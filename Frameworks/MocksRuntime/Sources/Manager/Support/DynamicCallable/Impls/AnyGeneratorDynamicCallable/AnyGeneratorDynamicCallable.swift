import MixboxFoundation
import MixboxGenerators

public final class AnyGeneratorDynamicCallable: DynamicCallable {
    private let anyGenerator: AnyGenerator
    private let typeErasedAnyGenerator: TypeErasedAnyGenerator
    private let anyGeneratorDynamicCallableBehavior: AnyGeneratorDynamicCallableBehavior
    
    public init(
        anyGenerator: AnyGenerator,
        typeErasedAnyGenerator: TypeErasedAnyGenerator,
        anyGeneratorDynamicCallableBehavior: AnyGeneratorDynamicCallableBehavior)
    {
        self.anyGenerator = anyGenerator
        self.typeErasedAnyGenerator = typeErasedAnyGenerator
        self.anyGeneratorDynamicCallableBehavior = anyGeneratorDynamicCallableBehavior
    }
    
    public func call<ReturnValue>(
        nonEscapingCallArguments: NonEscapingCallArguments,
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
            // Case with closures should be handled with some special code.
            //
            let customizableReturnValue = try anyGeneratorDynamicCallableBehavior.call(
                arguments: convert(
                    arguments: nonEscapingCallArguments.arguments
                ),
                returnValueType: returnValueType
            )
            
            switch customizableReturnValue {
            case .automatic:
                return .returned(try anyGenerator.generate())
            case let .customized(value):
                switch value {
                case let .error(error):
                    return .threw(error)
                case let .returnValue(returnValue):
                    return .returned(returnValue)
                }
            }
        } catch {
            return .canNotProvideResult(error)
        }
    }
    
    private func convert(
        arguments: [NonEscapingCallArgument])
        -> [AnyGeneratorDynamicCallableFunctionArgument]
    {
        return arguments.map(convert)
    }
    
    private func convert(
        argument: NonEscapingCallArgument)
        -> AnyGeneratorDynamicCallableFunctionArgument
    {
        let closureReflection: ClosureArgumentValueReflection
        let isNil: Bool
        
        switch argument.value {
        case let .regular(nested):
            return .nonClosure(
                AnyGeneratorDynamicCallableNonClosureArgument(
                    name: argument.name,
                    label: argument.label,
                    type: argument.type,
                    value: nested.value
                )
            )
        case let .escapingClosure(nested):
            closureReflection = nested.reflection
            isNil = false
        case let .optionalEscapingClosure(nested):
            closureReflection = nested.reflection
            isNil = nested.value == nil
        case let .nonEscapingClosure(nested):
            closureReflection = nested.reflection
            isNil = false
        }
        
        return .closure(
            AnyGeneratorDynamicCallableClosureArgumentImpl(
                name: argument.name,
                label: argument.label,
                type: argument.type,
                isNil: isNil,
                closureReflection: closureReflection,
                typeErasedAnyGenerator: typeErasedAnyGenerator
            )
        )
    }
}
