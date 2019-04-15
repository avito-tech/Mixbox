public enum HttpMethod: String {
    case options, get, head, post, put, patch, delete, trace, connect
    
    public var value: String {
        return rawValue.uppercased()
    }
}
