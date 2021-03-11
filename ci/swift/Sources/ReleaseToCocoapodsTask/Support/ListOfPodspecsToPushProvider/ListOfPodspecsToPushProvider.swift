// Provides a list of podspecs to push in a particular order.
// First podspecs should be pushed first. For example,
// if podspec A depends on podspec B, the order should be B => A,
// otherwise (A => B) A can't be pushed correctly, podspec validation
// will fail, because B is either not pused before or is an old version
// that is not compatible with current version (that A uses).
//
// Podspecs are just names like "MixboxFoundation". All podspecs
// are just contained in a root directory of repo.
public protocol ListOfPodspecsToPushProvider {
    func listOfPodspecsToPush() throws -> [String]
}
