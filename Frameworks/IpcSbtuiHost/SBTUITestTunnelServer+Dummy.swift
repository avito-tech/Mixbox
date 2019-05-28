#if MIXBOX_CI_IS_LINTING_PODSPECS
    public final class SBTUITestTunnelServer {
        public static func takeOff() {}
        public static func takeOffCompleted(_ completed: Bool) {}
        public static func registerCustomCommandNamed(_ commandName: String, block: ((NSObject?) -> NSObject?)) {}
        public static func unregisterCommandNamed(_ commandName: String) {}
    }
#endif
