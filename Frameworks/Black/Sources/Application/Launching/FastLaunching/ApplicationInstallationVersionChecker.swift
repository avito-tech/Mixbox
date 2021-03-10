public protocol ApplicationInstallationVersionChecker {
    func sameVersionOfTestedApplicationIsAlreadyInstalled() -> Bool
}
