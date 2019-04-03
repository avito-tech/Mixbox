import Foundation

public struct ChecksTestsViewConfiguration: Codable {
    public struct ReloadSettings: Codable {
        public let defaultConfig: Bool
        public let setId: Bool
        public let userConfig: Bool
        public let addSubview: Bool
        
        public static var `default`: ReloadSettings {
            return ReloadSettings(
                defaultConfig: true,
                setId: true,
                userConfig: true,
                addSubview: true
            )
        }
    }
    
    public struct Action: Codable {
        public let reloadSettings: ReloadSettings
        public let delay: TimeInterval
        
        public static var `default`: Action {
            return Action(
                reloadSettings: .default,
                delay: 0
            )
        }
    }
    
    public let actions: [Action]
    
    public static var `default`: ChecksTestsViewConfiguration {
        return ChecksTestsViewConfiguration(
            actions: [.default]
        )
    }
}
