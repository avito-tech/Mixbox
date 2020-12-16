public protocol DefaultImplementationSettable: class {
    associatedtype MockedType
    
    // TODO: Should we allow resetting it (making argument optional)?
    @discardableResult
    func setDefaultImplementation(_ defaultImplementation: MockedType) -> MixboxMocksRuntimeVoid
}
