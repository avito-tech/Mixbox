import MixboxGenerators

public protocol ConfiguredDynamicLookupGeneratorProvider {
    func configuredDynamicLookupGenerator<T: RepresentableByFields, ModifiedConfigurator>(
        type: T.Type,
        modifyConfigurator: (TestFailingDynamicLookupConfigurator<T>) throws -> ModifiedConfigurator,
        configure: @escaping (ModifiedConfigurator) throws -> ())
        throws
        -> DynamicLookupGenerator<T>
}

extension ConfiguredDynamicLookupGeneratorProvider {
    public func configuredDynamicLookupGenerator<T: RepresentableByFields, ModifiedConfigurator>(
        type: T.Type = T.self,
        modifyConfigurator: (TestFailingDynamicLookupConfigurator<T>) throws -> ModifiedConfigurator,
        configure: @escaping (ModifiedConfigurator) throws -> ())
        throws
        -> DynamicLookupGenerator<T>
    {
        return try configuredDynamicLookupGenerator(
            type: type,
            modifyConfigurator: modifyConfigurator,
            configure: configure
        )
    }
    
    public func configuredDynamicLookupGenerator<T: RepresentableByFields>(
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        throws
        -> DynamicLookupGenerator<T>
    {
        return try configuredDynamicLookupGenerator(
            type: type,
            modifyConfigurator: { $0 },
            configure: configure
        )
    }
}
