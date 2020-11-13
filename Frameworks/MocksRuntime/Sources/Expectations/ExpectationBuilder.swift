import MixboxFoundation

public protocol ExpectationBuilder: class {
    init(
        mockManager: MockManager,
        times: FunctionalMatcher<Int>,
        fileLine: FileLine)
}
