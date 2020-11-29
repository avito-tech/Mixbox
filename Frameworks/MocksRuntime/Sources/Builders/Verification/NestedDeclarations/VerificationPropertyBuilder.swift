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
            recordedCallArgumentsMatcher: any(),
            fileLine: FileLine(file: file, line: line)
        )
    }
}

public final class VerificationMutablePropertyBuilder<PropertyType>:
    VerificationImmutablePropertyBuilder<PropertyType>
{
    // TODO: Support detecting closures? Now only `RecordedCallArgument.regular` is returned.
    public func set<NewValueMatcher: Matcher>(
        _ newValueMatcher: NewValueMatcher,
        file: StaticString = #file,
        line: UInt = #line)
        -> VerificationFunctionBuilder<PropertyType, ()>
        where
        NewValueMatcher.MatchingType == RecordedCallArguments
    {
        let recordedCallArgumentsMatcher = FunctionalMatcher<RecordedCallArguments>(
            matchingFunction: { (other: RecordedCallArguments) -> Bool in
                newValueMatcher.valueIsMatching(
                    RecordedCallArguments(
                        arguments: [
                            RecordedCallArgument.regular(value: other)
                        ]
                    )
                )
            }
        )
        
        return VerificationFunctionBuilder<PropertyType, ()>(
            functionIdentifier: FunctionIdentifierFactory.variableFunctionIdentifier(
                variableName: variableName,
                type: .set
            ),
            mockManager: mockManager,
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
            fileLine: FileLine(file: file, line: line)
        )
    }
}
