import MixboxGenerators

// Entity for reusing code that can generate something `RepresentableByFields`
// with any cofigurator, for example, with indexed configurator for generating arrays and dictionaries.
public protocol TestFailingObjectGeneratorWithConfiguratorModification {
    func generate<T: RepresentableByFields, MC>(
        type: T.Type,
        modifyConfigurator: (TestFailingDynamicLookupConfigurator<T>) throws -> MC,
        configure: @escaping (MC) throws -> ())
        -> T
}

extension TestFailingObjectGeneratorWithConfiguratorModification {
    public func generate<T: RepresentableByFields, MC>(
        type: T.Type = T.self,
        modifyConfigurator: (TestFailingDynamicLookupConfigurator<T>) throws -> MC,
        configure: @escaping (MC) throws -> ())
        -> T
    {
        return generate(
            type: type,
            modifyConfigurator: modifyConfigurator,
            configure: configure
        )
    }
    
    public func generate<T: RepresentableByFields>(
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupConfigurator<T>) throws -> ())
        -> T
    {
        return generate(
            type: type,
            modifyConfigurator: { $0 },
            configure: configure
        )
    }
    
    public func generate<T: RepresentableByFields>(
        type: T.Type = T.self,
        index: Int,
        configure: @escaping (TestFailingDynamicLookupConfiguratorWithIndex<T>) throws -> ())
        -> T
    {
        return generate(
            type: type,
            modifyConfigurator: { $0.with(index: index) },
            configure: configure
        )
    }
}
