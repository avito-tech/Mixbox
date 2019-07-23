#if MIXBOX_ENABLE_IN_APP_SERVICES

// TODO: Clean-up automatically (on deinit)
// TODO: Type-erased identifier? (Hashable/Codable; e.g. AnyHashable & AnyCodable)
public final class IpcObjectId: Codable, Hashable {
    public let string: String
    
    public init(string: String) {
        self.string = string
    }
    
    public static var uuid: IpcObjectId {
        return IpcObjectId(string: UUID().uuidString)
    }
    
    public static func ==(lhs: IpcObjectId, rhs: IpcObjectId) -> Bool {
        return lhs.string == rhs.string
    }
    
    public func hash(into hasher: inout Hasher) {
        string.hash(into: &hasher)
    }
}

#endif
