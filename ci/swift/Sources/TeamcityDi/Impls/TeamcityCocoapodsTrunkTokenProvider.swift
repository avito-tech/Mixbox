import Cocoapods
import CiFoundation

// Move to some "Teamcity" package
public final class TeamcityCocoapodsTrunkTokenProvider: CocoapodsTrunkTokenProvider {
    private let environmentProvider: EnvironmentProvider
    
    public init(environmentProvider: EnvironmentProvider) {
        self.environmentProvider = environmentProvider
    }
    
    public func cocoapodsTrunkToken() throws -> String {
        return try environmentProvider
            .environment["MIXBOX_CI_COCOAPODS_TRUNK_TOKEN"]
            .unwrapOrThrow()
    }
}
