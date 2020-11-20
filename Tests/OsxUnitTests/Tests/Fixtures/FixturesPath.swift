import PathKit

final class FixturesPath {
    private init() {}
    
    static let folderPath = Path(#file) + ".."
    
    static let fixtureProtocolPath = folderPath + "FixtureProtocol.swift"
    static let fixtureProtocolMockPath = folderPath + "MockFixtureProtocol.swift"
}
