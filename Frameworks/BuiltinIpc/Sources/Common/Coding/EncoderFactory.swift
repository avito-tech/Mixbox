public protocol EncoderFactory: class {
    func encoder() -> JSONEncoder
}
