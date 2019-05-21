import CiFoundation

final class EnvironmentProviderMock: EnvironmentProvider {
    let environment: [String: String]
    
    init(environment: [String: String]) {
        self.environment = environment
    }
}
