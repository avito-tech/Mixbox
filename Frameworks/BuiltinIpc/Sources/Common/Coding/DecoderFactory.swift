public protocol DecoderFactory: class {
    func decoder() -> JSONDecoder
}
