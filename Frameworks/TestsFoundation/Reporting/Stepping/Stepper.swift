// This utility makes a tree of steps that is easy to use and is compatible
// with everything (including XCUIActivity that requires closures).
public class Stepper<BeforeResult, AfterResult> {
    public typealias CombineFunction<T> = (
        _ beforeResult: BeforeResult,
        _ afterResult: AfterResult?,
        _ children: [T])
        -> T
    
    public final class WrappedResultWithAfterResult<T> {
        public let afterResult: AfterResult
        public let wrappedResult: T
        
        public init(
            afterResult: AfterResult,
            wrappedResult: T)
        {
            self.afterResult = afterResult
            self.wrappedResult = wrappedResult
        }
    }
    
    private class StepForPointer {
        var afterResult: AfterResult?
        var steps = [Step]()
    }
    
    private final class Step: StepForPointer {
        let beforeResult: BeforeResult
        
        init(beforeResult: BeforeResult) {
            self.beforeResult = beforeResult
        }
        
        func combineResults<T>(combineFunction: CombineFunction<T>) -> T {
            let children = steps.map { step in
                step.combineResults(combineFunction: combineFunction)
            }
            return combineFunction(beforeResult, afterResult, children)
        }
    }
    
    private let root = StepForPointer()
    private var pointer: StepForPointer
    
    public init() {
        pointer = root
    }
    
    public func steps<T>(combineFunction: CombineFunction<T>) -> [T] {
        return root.steps.map { $0.combineResults(combineFunction: combineFunction) }
    }
    
    public func step<T>(beforeResult: BeforeResult, closure: () -> WrappedResultWithAfterResult<T>) -> T {
        let substep = Step(beforeResult: beforeResult)
        let oldPointer = pointer
        pointer.steps.append(substep)
        pointer = substep
        
        let result = closure()
        substep.afterResult = result.afterResult
        
        pointer = oldPointer
        
        return result.wrappedResult
    }
}
