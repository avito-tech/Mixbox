import MixboxFoundation

public class VerificationImmutablePropertyBuilder<PropertyType> {
    public typealias PropertyType = PropertyType
    
    fileprivate let mockManager: MockManager
    fileprivate var variableName: String
    
    public init(
        variableName: String,
        mockManager: MockManager)
    {
        self.mockManager = mockManager
        self.variableName = variableName
    }
    
    public func get(
        file: StaticString = #file,
        line: UInt = #line)
        -> VerificationFunctionBuilder<(), PropertyType>
    {
        return VerificationFunctionBuilder<(), PropertyType>(
            functionIdentifier: FunctionIdentifierFactory.variableFunctionIdentifier(
                variableName: variableName,
                type: .get
            ),
            mockManager: mockManager,
            argumentsMatcher: any(),
            fileLine: FileLine(file: file, line: line)
        )
    }
}

public final class VerificationMutablePropertyBuilder<PropertyType>:
    VerificationImmutablePropertyBuilder<PropertyType>
{
    public func set<NewValueMatcher: Matcher>(
        _ newValueMatcher: NewValueMatcher,
        file: StaticString = #file,
        line: UInt = #line)
        -> VerificationFunctionBuilder<PropertyType, ()>
        where
        NewValueMatcher.MatchingType == PropertyType
    {
        let argumentsMatcher = FunctionalMatcher<PropertyType>(
            matchingFunction: { (other: PropertyType) -> Bool in
                newValueMatcher.valueIsMatching(other)
            }
        )
        
        return VerificationFunctionBuilder<PropertyType, ()>(
            functionIdentifier: FunctionIdentifierFactory.variableFunctionIdentifier(
                variableName: variableName,
                type: .set
            ),
            mockManager: mockManager,
            argumentsMatcher: argumentsMatcher,
            fileLine: FileLine(file: file, line: line)
        )
    }
}
