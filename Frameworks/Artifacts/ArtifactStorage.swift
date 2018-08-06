// What it is:
// Handy interface for storing files on disk with complex rules.
//
// What it is NOT:
// Very generic and customizable utility for storing files.
//
// Example usage:
//
//  artifactStorage.store(
//      artifact: Artifact(
//          name: "screenshotAtFailure",
//          content: .screenshot(screenshot)
//      ),
//      pathComponents: ["testcase42", "screenshots"]
//  )
//
// For every artifact it creates all intermediate folders.
//
// Collisions:
//
// #1. If there is an artifact with same name, it adds index to name.
//
// #2. If there are artifacts with same pathComponents, files will be added
// to directories without adding index to directories.
//
// Note that if you store multiple artifacts, the bunch of artifacts has a name and it will follow rule #1.
//
// Examples:
//
//  store(artifact: Artifact(name: "foo", content: .artifacts([...]), pathComponents: ["bar"])
//  store(artifact: Artifact(name: "foo", content: .artifacts([...]), pathComponents: ["bar"])
//
// There will be folders:
//
// .../bar/foo
// .../bar/foo_0
//
// The way it resolves collisions (e.g. add indexes) is not specified! Don't rely on it.
//
public enum ArtifactStorageResult {
    case stored(path: String)
    case failure
}

public protocol ArtifactStorage {
    @discardableResult
    func store(
        artifact: Artifact,
        pathComponents: [String])
        -> ArtifactStorageResult
}
