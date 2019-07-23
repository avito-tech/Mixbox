// TODO: Remove this enum after removing SBTUITestTunnel dependency.
// The interface is not ideal, it was made based on current implementation of SBTUITestTunnel
public enum StubResponseBuilderResponseValue: Equatable {
    case data(Data)
    case string(String)
    case file(String)
    
    public static func ==(l: StubResponseBuilderResponseValue, r: StubResponseBuilderResponseValue) -> Bool {
        switch (l, r) {
        case let (.data(l), .data(r)):
            return l == r
        case let (.string(l), .string(r)):
            return l == r
        case let (.file(l), .file(r)):
            return l == r
        default:
            return false
        }
    }
}
