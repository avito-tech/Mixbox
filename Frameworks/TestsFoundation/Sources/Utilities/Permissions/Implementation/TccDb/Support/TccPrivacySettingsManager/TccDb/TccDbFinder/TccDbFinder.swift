// Searches for TCC.db of current simulator
public protocol TccDbFinder: class {
    func tccDbPath() throws -> String
}
