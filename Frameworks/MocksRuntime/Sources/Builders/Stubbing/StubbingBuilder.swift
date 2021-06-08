import MixboxFoundation

public protocol StubbingBuilder: AnyObject {
    init(mockManager: MockManager, fileLine: FileLine)
}
