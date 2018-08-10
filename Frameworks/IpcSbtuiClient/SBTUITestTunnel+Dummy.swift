// To suppress warning when linting podspec
// TODO: Do it differently
#if !DEBUG
public final class SBTUITunneledApplication {
    func performCustomCommandNamed(_ commandName: String, object: Any?) -> Any? {
        return nil
    }
}
#endif
