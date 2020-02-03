public protocol RemoteCacheConfigProvider {
    func remoteCacheConfigJsonFilePath() throws -> String
}
