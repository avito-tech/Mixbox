import Foundation
import CiFoundation

public enum Env: String {
    case MIXBOX_CI_ALLURE_REPORTS_DIRECTORY
    case MIXBOX_CI_BLUEPILL_ZIP_PATH
    case MIXBOX_CI_BUILD_EXECUTABLE
    case MIXBOX_CI_DESTINATION
    case MIXBOX_CI_EMCEE_FBSIMCTL_URL
    case MIXBOX_CI_EMCEE_FBXCTEST_URL
    case MIXBOX_CI_EMCEE_PATH
    case MIXBOX_CI_EMCEE_QUEUE_SERVER_RUN_CONFIGURATION_URL
    case MIXBOX_CI_EMCEE_SHARED_QUEUE_DEPLOYMENT_DESTINATIONS_URL
    case MIXBOX_CI_EMCEE_URL
    case MIXBOX_CI_FILE_UPLOADER_URL
    case MIXBOX_CI_IS_CI_BUILD
    case MIXBOX_CI_REPORTS_PATH
    case MIXBOX_CI_TRAVIS_BUILD
    case MIXBOX_CI_UPLOADER_EXECUTABLE
    case MIXBOX_CI_LOG_LEVEL
    case MIXBOX_CI_USES_FBXCTEST
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
