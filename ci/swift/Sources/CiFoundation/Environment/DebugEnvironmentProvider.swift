import Foundation

// For debugging.
public final class DebugEnvironmentProvider: EnvironmentProvider {
    private let originalEnvironmentProvider: EnvironmentProvider
    
    public init(originalEnvironmentProvider: EnvironmentProvider) {
        self.originalEnvironmentProvider = originalEnvironmentProvider
    }
    
    public var environment: [String: String] {
        var environment = originalEnvironmentProvider.environment
        
        do {
            for (key, value) in try patch() {
                environment[key] = value
            }
        } catch {
            print("Skipping patching environment due to error: \(error)")
        }
        
        return environment
    }
    
    private func patch() throws -> [String: String] {
        let path = "~/.mixbox_ci_debug_environment"
        
        let whitespaceSeparatedEnvironment = try String(
            contentsOfFile: (path as NSString).expandingTildeInPath
        )
        
        var environmentAsDictionary = [String: String]()
        
        let equalsSignSeparatedKeyValues = whitespaceSeparatedEnvironment.split(
            separator: " ",
            omittingEmptySubsequences: false
        )
        
        for equalsSignSeparatedKeyValue in equalsSignSeparatedKeyValues {
            let keyValueAsArray = equalsSignSeparatedKeyValue.split(separator: "=", omittingEmptySubsequences: false)
            
            if keyValueAsArray.count == 2 {
                let key = String(keyValueAsArray[0])
                let value = String(keyValueAsArray[1])
                
                environmentAsDictionary[key] = value
            } else {
                print("\(path) should contain pairs of key value: \"A=B C=D E=F\", got this pair: \(equalsSignSeparatedKeyValue)")
            }
        }
        
        if environmentAsDictionary["LANG"] == nil {
            environmentAsDictionary["LANG"] = "en_US.UTF-8" // required by cocoapods
        }
        environmentAsDictionary["MIXBOX_CI_REPORTS_PATH"] = "/tmp/B4FA7EC5-D13C-4E7B-AEA1-A7B627EEFF4B"
        
        return environmentAsDictionary
    }
}
