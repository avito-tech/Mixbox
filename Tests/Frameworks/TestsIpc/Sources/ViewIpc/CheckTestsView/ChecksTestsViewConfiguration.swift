import Foundation

public final class ChecksTestsViewConfiguration: Codable {
    public final class ReloadSettings: Codable {
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
        
        public init(
            defaultConfig: Bool,
            setId: Bool,
            userConfig: Bool,
            addSubview: Bool)
        {
            self.defaultConfig = defaultConfig
            self.setId = setId
            self.userConfig = userConfig
            self.addSubview = addSubview
        }
    }
    
    public final class Action: Codable {
        public let reloadSettings: ReloadSettings
        public let delay: TimeInterval
        
        public static var `default`: Action {
            return Action(
                reloadSettings: .default,
                delay: 0
            )
        }
        
        public init(
            reloadSettings: ReloadSettings,
            delay: TimeInterval)
        {
            self.reloadSettings = reloadSettings
            self.delay = delay
        }
    }
    
    public let actions: [Action]
    
    public static var `default`: ChecksTestsViewConfiguration {
        return ChecksTestsViewConfiguration(
            actions: [.default]
        )
    }
    
    public init(
        actions: [Action])
    {
        self.actions = actions
    }
}
