import MixboxArtifacts

public protocol AllureResultsStorage {
    func store(artifact: Artifact, completion: @escaping (AllureAttachment?) -> ())
    func store(allureResult: AllureResult, completion: @escaping () -> ())
    func store(allureContainer: AllureContainer, completion: @escaping () -> ())
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
    
    public func store(
        artifact: Artifact,
        completion: @escaping (AllureAttachment?) -> ())
    {
        let allureArtifact = Artifact(
            name: artifactName(uuid: AllureUuid.random(), suffix: .attachment),
            content: artifact.content
        )
        
        artifactStorage.store(artifact: allureArtifact, pathComponents: artifactsPath) { result in
            switch result {
            case .stored(let path):
                let attachment = AllureAttachment(
                    name: artifact.name,
                    source: (path as NSString).lastPathComponent
                )
                completion(attachment)
            case .failure:
                completion(nil)
            }
        }
    }
    
    public func store(
        allureResult: AllureResult,
        completion: @escaping () -> ())
    {
        storeJson(
            uuid: allureResult.uuid,
            suffix: .result,
            encodable: allureResult,
            completion: completion
        )
    }
    
    public func store(
        allureContainer: AllureContainer,
        completion: @escaping () -> ())
    {
        storeJson(
            uuid: allureContainer.uuid,
            suffix: .container,
            encodable: allureContainer,
            completion: completion
        )
    }
    
    private func storeJson<T: Encodable>(
        uuid: AllureUuid,
        suffix: Suffix,
        encodable: T,
        completion: @escaping () -> ())
    {
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
        
        artifactStorage.store(
            artifact: artifact,
            pathComponents: artifactsPath,
            completion: { _ in
                completion()
            }
        )
    }
    
    private func artifactName(uuid: AllureUuid, suffix: Suffix) -> String {
        return uuid.string + "-" + suffix.rawValue
    }
}
