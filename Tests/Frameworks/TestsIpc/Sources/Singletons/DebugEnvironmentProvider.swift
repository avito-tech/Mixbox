import Foundation
import MixboxFoundation

public final class DebugEnvironmentProvider: EnvironmentProvider {
    private let originalEnvironmentProvider: EnvironmentProvider
    
    public init(originalEnvironmentProvider: EnvironmentProvider) {
        self.originalEnvironmentProvider = originalEnvironmentProvider
    }
    
    public lazy var environment: [String: String] = {
        let environment = originalEnvironmentProvider.environment
        
        do {
            return environment.merging(
                try patch(),
                uniquingKeysWith: { _, patched in patched }
            )
        } catch {
            print("Skipping patching environment due to error: \(error)")
        }
        
        return environment
    }()
    
    private func patch() throws -> [String: String] {
        let home = try originalEnvironmentProvider.environment["SIMULATOR_HOST_HOME"].unwrapOrThrow()
        let path = "\(home)/.mixbox_ci_debug_environment"
        
        let whitespaceSeparatedEnvironment = try String(
            contentsOfFile: (path as NSString).expandingTildeInPath
        )
        
        var environmentAsDictionary = [String: String]()
        
        let equalsSignSeparatedKeyValues = whitespaceSeparatedEnvironment.split(
            separator: " ",
            omittingEmptySubsequences: true
        )
        
        for equalsSignSeparatedKeyValue in equalsSignSeparatedKeyValues {
            let keyValueAsArray = equalsSignSeparatedKeyValue.split(separator: "=", omittingEmptySubsequences: true)
            
            if keyValueAsArray.count == 2 {
                let key = String(keyValueAsArray[0])
                let value = String(keyValueAsArray[1])
                
                environmentAsDictionary[key] = value
            } else {
                print("\(path) should contain pairs of key value: \"A=B C=D E=F\", got this pair: \(equalsSignSeparatedKeyValue)")
            }
        }
        
        return environmentAsDictionary
    }
}
