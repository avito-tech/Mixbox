public protocol CiLogger {
    func logBlock(
        name: String,
        body: () throws -> ()
    ) rethrows
}
