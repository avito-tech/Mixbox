#if MIXBOX_ENABLE_IN_APP_SERVICES

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
