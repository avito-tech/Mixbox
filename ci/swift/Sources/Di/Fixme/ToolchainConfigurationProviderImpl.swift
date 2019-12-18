import Emcee
import Models

public final class ToolchainConfigurationProviderImpl: ToolchainConfigurationProvider {
    public init() {
    }
    
    public func toolchainConfiguration() throws -> ToolchainConfiguration {
        return ToolchainConfiguration(
            developerDir: .useXcode(CFBundleShortVersionString: "11.2.1") // TODO: Pass via CI
        )
    }
}
