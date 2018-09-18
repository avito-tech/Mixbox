// TODO: Remove singleton
public final class CurrentApplicationDirectoryProvider {
    public static private(set) var currentApplicationDirectory: String? = {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            .first?
            .mb_deletingLastPathComponent
    }()
}
