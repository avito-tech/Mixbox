final class HashableNsObject: Hashable {
    lazy var hashValue: Int = object.hash
    let object: NSObject
    
    init(_ object: NSObject) {
        self.object = object
    }
    
    static func ==(l: HashableNsObject, r: HashableNsObject) -> Bool {
        return l.object.isEqual(r.object)
    }
}
