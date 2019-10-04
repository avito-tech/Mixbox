import MixboxReporting
import MixboxUiTestsFoundation
import MixboxArtifacts

final class StepLogMatcherBuilder {
    let title = PropertyMatcherBuilder("title", \StepLog.title)
    let startDate = PropertyMatcherBuilder("startDate", \StepLog.startDate)
    let stopDate = PropertyMatcherBuilder("stopDate", \StepLog.stopDate)
    let wasSuccessful = PropertyMatcherBuilder("wasSuccessful", \StepLog.wasSuccessful)
    
    let artifactsBefore = ArrayPropertyMatcherBuilder<StepLog, Artifact, ArtifactMatcherBuilder>(
        propertyName: "artifactsBefore",
        propertyKeyPath: \StepLog.artifactsBefore,
        matcherBuilder: ArtifactMatcherBuilder()
    )
    
    let artifactsAfter = ArrayPropertyMatcherBuilder<StepLog, Artifact, ArtifactMatcherBuilder>(
        propertyName: "artifactsAfter",
        propertyKeyPath: \StepLog.artifactsAfter,
        matcherBuilder: ArtifactMatcherBuilder()
    )
    
    let steps = ArrayPropertyMatcherBuilder<StepLog, StepLog, StepLogMatcherBuilder>(
        propertyName: "steps",
        propertyKeyPath: \StepLog.steps,
        matcherBuilder: StepLogMatcherBuilder()
    )
}

final class XcTestFailureMatcherBuilder {
    let description = PropertyMatcherBuilder("description", \XcTestFailure.description)
    let file = PropertyMatcherBuilder("file", \XcTestFailure.file)
    let line = PropertyMatcherBuilder("line", \XcTestFailure.line)
    let expected = PropertyMatcherBuilder("expected", \XcTestFailure.expected)
}

final class ArtifactMatcherBuilder {
    let name = PropertyMatcherBuilder("name", \Artifact.name)
    let content = PropertyMatcherBuilder("content", \Artifact.content)
}
