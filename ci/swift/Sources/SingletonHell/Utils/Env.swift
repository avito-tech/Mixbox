import Foundation
import CiFoundation

public enum Env: String {
    // Bash CI (to select Swift CI build)
    case MIXBOX_CI_BUILD_EXECUTABLE
    
    // Swift CI external envs:
    case MIXBOX_CI_DESTINATION
    case MIXBOX_CI_FILE_UPLOADER_URL
    case MIXBOX_CI_XCODE_VERSION
    
    // Swift CI external envs, Emcee:
    case MIXBOX_CI_EMCEE_PATH
    case MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL
    case MIXBOX_CI_EMCEE_URL
    case MIXBOX_CI_EMCEE_REMOTE_CACHE_CONFIG
    
    // Swift CI external envs, outdated:
    case MIXBOX_CI_REPORTS_PATH
    
    // Swift CI external envs, for manual executing:
    case MIXBOX_CI_AUTOCORRECT_ENABLED
    case MIXBOX_CI_RUN_ONLY_ONE_TEST
    
    // Swift CI internal envs (that are passed to tests):
    case MIXBOX_CI_USES_FBXCTEST // todo: remove from Mixbox
    case MIXBOX_CI_IS_CI_BUILD
    case MIXBOX_IPC_STARTER_TYPE
    case MIXBOX_CI_GRAPHITE_HOST
    case MIXBOX_CI_GRAPHITE_PORT
    case MIXBOX_CI_GRAPHITE_PREFIX
    
    // Cocoapods envs:
    case MIXBOX_PUSHSPEC_STYLE
}

extension EnvironmentProvider {
    public func get(env: Env) -> String? {
        return try? getOrThrow(env: env)
    }
    
    public func getOrThrow(env: Env) throws -> String {
        let key = env.rawValue
        
        guard let value = environment[key] else {
            throw ErrorString("No environment for key \(key)")
        }
        
        guard !value.isEmpty else {
            throw ErrorString("Environment for key \(key) is an empty string")
        }
        
        return value
    }
    
    public func getUrlOrThrow(env: Env) throws -> URL {
        return try URL(string: getOrThrow(env: env)).unwrapOrThrow()
    }
}
