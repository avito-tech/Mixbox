#if MIXBOX_ENABLE_IN_APP_SERVICES

final class HashableType: Hashable {
    private let type: Any.Type
    
    init(type: Any.Type) {
        self.type = type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(type)")
    }
    
    static func ==(lhs: HashableType, rhs: HashableType) -> Bool {
        return lhs.type == rhs.type
    }
}

#endif
