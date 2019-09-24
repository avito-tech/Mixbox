public protocol MixboxTestDestinationConfigurationsProvider {
    func mixboxTestDestinationConfigurations() throws -> [MixboxTestDestinationConfiguration]
}
