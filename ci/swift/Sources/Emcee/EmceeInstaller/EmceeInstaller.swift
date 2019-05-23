public typealias EmceeExecutablePath = String

public protocol EmceeInstaller {
    func installEmcee() throws -> EmceeExecutablePath
}
