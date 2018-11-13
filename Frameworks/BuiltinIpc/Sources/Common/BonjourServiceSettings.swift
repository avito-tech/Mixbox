public final class BonjourServiceSettings {
    // Bonjour service name.
    // Conventions: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/NetServices/Articles/domainnames.html#//apple_ref/doc/uid/TP40002460-SW1
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
