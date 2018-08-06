import MixboxArtifacts

// Описывает ошибку конкретного действия или проверки.
// Например, почему текст не прошел проверку, какой он был,
// или какие были скриншоты в скриншотном сравнении, какой был дифф.
public final class InteractionSpecificFailure {
    public let message: String
    public let artifacts: [Artifact]
    
    public init(message: String, artifacts: [Artifact] = []) {
        self.message = message
        self.artifacts = artifacts
    }
}
