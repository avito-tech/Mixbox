import Models

public protocol ToolchainConfigurationProvider {
    func toolchainConfiguration() throws -> ToolchainConfiguration
}
