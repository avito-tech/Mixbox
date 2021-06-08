// Searches for TCC.db of current simulator
public protocol TccDbFinder: AnyObject {
    func tccDbPath() throws -> String
}
