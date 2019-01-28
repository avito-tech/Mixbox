import MixboxArtifacts

public protocol AllureResultsStorage {
    func store(artifact: Artifact) -> AllureAttachment?
    func store(allureResult: AllureResult)
    func store(allureContainer: AllureContainer)
}

public final class AllureResultsStorageImpl: AllureResultsStorage {
    private let artifactStorage: ArtifactStorage
    private let artifactsPath = ["results"]
    
    // https://github.com/allure-framework/allure2-model/blob/master/allure2-model-api/src/main/java/io/qameta/allure/AllureConstants.java
    private enum Suffix: String {
        case result
        case container
        case testrun
        case attachment
    }
    
    public init(artifactStorage: ArtifactStorage) {
        self.artifactStorage = artifactStorage
    }
    
    public func store(artifact: Artifact) -> AllureAttachment? {
        let allureArtifact = Artifact(
            name: artifactName(uuid: AllureUuid.random(), suffix: .attachment),
            content: artifact.content
        )
        
        switch artifactStorage.store(artifact: allureArtifact, pathComponents: artifactsPath) {
        case .stored(let path):
            return AllureAttachment(
                name: artifact.name,
                source: (path as NSString).lastPathComponent
            )
        case .failure:
            return nil
        }
    }
    
    public func store(allureResult: AllureResult) {
        storeJson(
            uuid: allureResult.uuid,
            suffix: .result,
            encodable: allureResult
        )
    }
    
    public func store(allureContainer: AllureContainer) {
        storeJson(
            uuid: allureContainer.uuid,
            suffix: .container,
            encodable: allureContainer
        )
    }
    
    private func storeJson<T: Encodable>(uuid: AllureUuid, suffix: Suffix, encodable: T) {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(encodable) else {
            return
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        
        let artifact = Artifact(
            name: artifactName(uuid: uuid, suffix: suffix),
            content: .json(jsonString)
        )
        
        artifactStorage.store(artifact: artifact, pathComponents: artifactsPath)
    }
    
    private func artifactName(uuid: AllureUuid, suffix: Suffix) -> String {
        return uuid.string + "-" + suffix.rawValue
    }
}
