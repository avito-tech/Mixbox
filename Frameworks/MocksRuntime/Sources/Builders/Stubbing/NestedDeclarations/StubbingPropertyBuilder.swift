import MixboxFoundation
import MixboxTestsFoundation

public class StubbingImmutablePropertyBuilder<PropertyType> {
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
        -> StubbingFunctionBuilder<(), PropertyType>
    {
        return StubbingFunctionBuilder(
            mockManager: mockManager,
            functionIdentifier: FunctionIdentifierFactory.variableFunctionIdentifier(
                variableName: variableName,
                type: .get
            ),
            recordedCallArgumentsMatcher: any(),
            fileLine: FileLine(file: file, line: line)
        )
    }
}

public final class StubbingMutablePropertyBuilder<PropertyType>:
    StubbingImmutablePropertyBuilder<PropertyType>
{
    public func set(
        _ newValueMatcher: Matcher<PropertyType>,
        file: StaticString = #file,
        line: UInt = #line)
        -> StubbingFunctionBuilder<PropertyType, ()>
    {
        let recordedCallArgumentsMatcher = RecordedCallArgumentsMatcherBuilder()
            .matchNext(newValueMatcher)
            .matcher()
        
        return StubbingFunctionBuilder(
            mockManager: mockManager,
            functionIdentifier: FunctionIdentifierFactory.variableFunctionIdentifier(
                variableName: variableName,
                type: .set
            ),
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
            fileLine: FileLine(file: file, line: line)
        )
    }
    
    private static func unwrapNewValue<PropertyType>(recordedCallArguments: RecordedCallArguments) -> PropertyType? {
        // Setters can have only 1 argument.
        return recordedCallArguments.arguments.mb_only?.value.typedNestedValue()
    }
}
