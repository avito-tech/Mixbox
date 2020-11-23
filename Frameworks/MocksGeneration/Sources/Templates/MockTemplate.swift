import SourceryRuntime

public final class MockTemplate {
    private let protocolType: Protocol
    private let moduleName: String
    
    public init(
        protocolType: Protocol,
        moduleName: String)
    {
        self.protocolType = protocolType
        self.moduleName = moduleName
    }
    
    // swiftlint:disable function_body_length
    public func render() throws -> String {
        let stubbingBuilderTemplate = BuilderTemplate(
            protocolType: protocolType,
            builderType: "Stubbing"
        )
        
        let verifcationBuilderTemplate = BuilderTemplate(
            protocolType: protocolType,
            builderType: "Verification"
        )
        
        // About need of BaseMockXxx classes:
        //
        // 1. Any properties should be private to avoid name collisions.
        //    Unlike methods, properties can not be overloaded, so name collisons can arise.
        //    Private properties can not collide with properties defined in subclasses.
        // 2. Fileprivate declarations can not collide with those defined in other files.
        // 3. Fileprivate classes can be a used in a signature of functions to make them
        //    a unique overloads if function with same name is in mocked protocol.
        //    However, fileprivate classes can lead to collisions if mocks are generated
        //    into same file.
        // 4. So just `MixboxMocksRuntimeVoid` is used to resolve possible collisions.
        //    It doesn't guarantee 100% avoidance of collisions, for example, if
        //    user deliberately same signature of mocke function, with `MixboxMocksRuntimeVoid`.
        //    But that's not the case worth supporting.
        
        let baseMockName = "BaseMock\(protocolType.name)"
        
        // TODO: It's good to add module name to a protocol, example: `MyModule.MyProtocol`
        // instead of just `MyProtocol`. However, currently there is an issue that for some reason
        // files from other modules are being generated, maybe because SourceKit have information
        // about those types in cache, I don't know.
        let protocolName = protocolType.name
        
        return """
        class \(baseMockName):
            MixboxMocksRuntime.BaseMock,
            MixboxMocksRuntime.DefaultImplementationSettable
        {
            typealias MockedType = \(protocolName)
            
            private var defaultImplementation: MockedType?
            
            fileprivate final func getDefaultImplementation(_: MixboxMocksRuntimeVoid.Type) -> MockedType? {
                return defaultImplementation
            }
        
            @discardableResult
            final func setDefaultImplementation(_ defaultImplementation: MockedType) -> MixboxMocksRuntimeVoid {
                self.defaultImplementation = defaultImplementation
        
                return MixboxMocksRuntimeVoid()
            }
        }
        
        final class Mock\(protocolType.name):
            \(baseMockName),
            \(protocolName),
            MixboxMocksRuntime.Mock
        {
            \(try stubbingBuilderTemplate.render().indent())
        
            \(try verifcationBuilderTemplate.render().indent())

            \(try ProtocolImplementationTemplate(protocolType: protocolType).render().indent())
        }
        """
    }
}
