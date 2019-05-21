import Foundation

// Translated from `variables.sh`.
// TODO: Rewrite.
public final class Variables {
    private static let tmpdir = newTemporaryDirectory()
    
    public static func derivedDataPath() -> String {
        return temporaryDirectory() + "/dd"
    }
    
    public static func temporaryDirectory() -> String {
        return tmpdir
    }
    
    public static func newTemporaryDirectory() -> String {
        return NSTemporaryDirectory() + "/" + uuidgen()
    }
}
