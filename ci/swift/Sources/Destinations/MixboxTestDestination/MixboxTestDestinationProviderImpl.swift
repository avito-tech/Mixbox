import CiFoundation

public final class MixboxTestDestinationProviderImpl: MixboxTestDestinationProvider {
    private let mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider
    
    public init(
        mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider)
    {
        self.mixboxTestDestinationConfigurationsProvider = mixboxTestDestinationConfigurationsProvider
    }
    
    public func mixboxTestDestination() throws -> MixboxTestDestination {
        let configurations = try mixboxTestDestinationConfigurationsProvider.mixboxTestDestinationConfigurations()
        
        guard let first = configurations.first, configurations.count == 1 else {
            throw ErrorString("Expected to have exactly 1 test destination configuration")
        }
        
        return first.testDestination
    }
}
