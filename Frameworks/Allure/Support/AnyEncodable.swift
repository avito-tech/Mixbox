final class AnyEncodable: Encodable {
    let encodeClosure: (Encoder) throws -> ()
    
    init(_ encodable: Encodable) {
        self.encodeClosure = { encoder in
            try encodable.encode(to: encoder)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
