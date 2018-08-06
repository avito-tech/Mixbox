// "Find Implicit Dependencies" in Xcode builds even the code that shouldn't compile,
// we had removed the code via `:configuration => 'Test'` in Podfile, but it continued to build (but not to link).
//
// There is a protective measure in SBTUITestTunnelServer to disable code if DEBUG definition is not set.
//
// We make a class with no implementation here. Without it the project fails to build in Xcode.
// We are also exclude it from linking via Podfile. So the release is not affected.
#if !DEBUG
    public final class SBTUITestTunnelServer {
        public static func takeOff() {}
        public static func takeOffCompleted(_ completed: Bool) {}
        public static func registerCustomCommandNamed(_ commandName: String, block: ((NSObject?) -> NSObject?)) {}
        public static func unregisterCommandNamed(_ commandName: String) {}
    }
#endif
