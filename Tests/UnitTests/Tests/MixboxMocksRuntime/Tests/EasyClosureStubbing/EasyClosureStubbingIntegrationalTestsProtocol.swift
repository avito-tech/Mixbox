typealias SomeTypealiasToClosure = (_ arg1: Int, _ arg2: Int) -> ()

protocol EasyClosureStubbingIntegrationalTestsProtocol {
    // Just to test if closure name isn't hardcoded
    func voidFunctionWithNameVariant0(completion: (Int) -> ())
    func voidFunctionWithNameVariant1(closure: (Int) -> ())
    
    func functionWithVoidArgumentsInClosure(closure: () -> ())
    
    func nonVoidFunction(completion: (Int) -> ()) -> Int
    
    func functionWithClosuresWithSameNames(completion: () -> (), completion: () -> ())
    
    func functionWithClosureViaTypealias(closure: SomeTypealiasToClosure)
    func functionWithEscapingClosureViaTypealias(closure: @escaping SomeTypealiasToClosure)
    
    func functionWithClosureWithNestedClosure(closure: (() -> ()) -> ())
}
