#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

open class Generator<T> {
    public typealias GenerateFunction = () throws -> T
    
    private let generateFunction: GenerateFunction
    
    public init(generateFunction: @escaping GenerateFunction) {
        self.generateFunction = generateFunction
    }
    
    public func generate() throws -> T {
        return try generateFunction()
    }
}

#endif
