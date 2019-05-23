public protocol RuntimeDumpFileLoader {
    func load(path: String) throws -> RuntimeDump
}
