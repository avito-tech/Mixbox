// Translated from `build.sh`.
// TODO: Rewrite.
public final class BuildUtils {
    public static func buildIos(
        folder: String,
        action: String,
        scheme: String,
        workspace: String,
        xcodeDestination: String,
        xcodebuildPipeFilter: String = "tee")
        throws
    {
        try build(
            xcodebuildPipeFilter: xcodebuildPipeFilter,
            folder: try repoRoot() + "/" + folder,
            args: [
                action,
                "-workspace", "\(workspace).xcworkspace",
                "-scheme", scheme,
                "-sdk", "iphonesimulator",
                "-derivedDataPath", Variables.derivedDataPath(),
                "-destination", xcodeDestination
            ]
        )
    }
    
    public static func buildMacOs(
        folder: String,
        action: String,
        scheme: String,
        workspace: String)
        throws
    {
        try build(
            xcodebuildPipeFilter: "tee",
            folder: try repoRoot() + "/" + folder,
            args: [
                action,
                "-workspace", "\(workspace).xcworkspace",
                "-scheme", scheme,
                "-derivedDataPath", Variables.derivedDataPath()
            ]
        )
    }
    
    public static func build(
        xcodebuildPipeFilter: String,
        folder: String,
        args: [String])
        throws
    {
        let derivedDataPath = Variables.derivedDataPath()
        
        print("Building using xcodebuild...")
        
        _ = try? bash("rm -rf \"\(derivedDataPath)\"")
        try bash("mkdir -p \"\(derivedDataPath)\"")
        
        try bash(
            command: "pod install || pod install --repo-update",
            currentDirectory: folder
        )
        
        let argsString = args.map { "\"\($0)\"" }.joined(separator: " ")
        try bash(
            command:
            """
            set -o pipefail
            xcodebuild \(argsString) | \(xcodebuildPipeFilter)
            """,
            currentDirectory: folder
        )
        
        _ = try? bash(
            command: """
            # Work around a bug when xcodebuild puts Build and Indexes folders to a pwd instead of dd/
            
            [ -d "Build" ] && echo "Moving Build/ -> \(derivedDataPath)/" && mv -f "Build" "\(derivedDataPath)" || true
            [ -d "Index" ] && echo "Moving Index/ -> \(derivedDataPath)/" && mv -f "Index" "\(derivedDataPath)" || true
            """,
            currentDirectory: folder
        )
    }
}
