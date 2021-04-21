import MixboxGenerators
import MixboxFoundation

public final class AnyGeneratorDynamicCallableClosureArgumentImpl:
    AnyGeneratorDynamicCallableClosureArgument
{
    public let name: String?
    public let label: String?
    public let type: Any.Type
    public let isNil: Bool
    
    private let typeErasedAnyGenerator: TypeErasedAnyGenerator
    private let closureReflection: ClosureArgumentValueReflection
    
    public init(
        name: String?,
        label: String?,
        type: Any.Type,
        isNil: Bool,
        closureReflection: ClosureArgumentValueReflection,
        typeErasedAnyGenerator: TypeErasedAnyGenerator)
    {
        self.name = name
        self.label = label
        self.type = type
        self.isNil = isNil
        self.closureReflection = closureReflection
        self.typeErasedAnyGenerator = typeErasedAnyGenerator
    }
    
    // MARK: - AnyGeneratorDynamicCallableClosureArgument
    
    public var argumentTypes: [Any.Type] {
        return closureReflection.argumentTypes
    }
    
    public var returnValueType: Any.Type {
        return closureReflection.returnValueType
    }
    
    public func call<ReturnValue>(
        arguments: CustomizableArray<Any>)
        throws
        -> ThrowingFunctionResult<ReturnValue>
    {
        return try closureReflection.call(
            arguments: try materialize(
                arguments: arguments
            )
        )
    }
    
    // MARK: - Private
    
    private func materialize(arguments: CustomizableArray<Any>) throws -> [Any] {
        let customizableScalars: [CustomizableScalar<Any>]
        
        switch arguments {
        case .automatic:
            customizableScalars = argumentTypes.map { _ in .automatic }
        case let .customized(nested):
            customizableScalars = nested
        }
        
        return try customizableScalars.mb_zip(sequenceOfSameLength: argumentTypes).map { pair in
            let (customizableScalar, argumentType) = try pair.unzip()
            
            return try materialize(
                argument: customizableScalar,
                argumentType: argumentType
            )
        }
    }
    
    private func materialize(
        argument: CustomizableScalar<Any>,
        argumentType: Any.Type)
        throws
        -> Any
    {
        switch argument {
        case .automatic:
            return try typeErasedAnyGenerator.generate(type: argumentType)
        case let .customized(nested):
            return nested
        }
    }
}
