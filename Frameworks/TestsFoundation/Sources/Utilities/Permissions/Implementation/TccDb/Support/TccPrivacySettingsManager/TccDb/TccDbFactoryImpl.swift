import MixboxFoundation
import MixboxUiKit

public final class TccDbFactoryImpl: TccDbFactory {
    private let tccDbFinder: TccDbFinder
    private let iosVersionProvider: IosVersionProvider
    
    public init(
        tccDbFinder: TccDbFinder,
        iosVersionProvider: IosVersionProvider)
    {
        self.tccDbFinder = tccDbFinder
        self.iosVersionProvider = iosVersionProvider
    }
    
    public func tccDb() throws -> TccDb {
        do {
            let tccDbPath = try tccDbFinder.tccDbPath()
            
            return ErrorsWrappingTccDb(
                tccDb: try tccDb(path: tccDbPath)
            )
        } catch {
            throw ErrorString(
                """
                Failed to call `\(type(of: self)).tccDb()`: \(error)
                """
            )
        }
    }
    
    private func tccDb(path: String) throws -> TccDb {
        if iosVersionProvider.iosVersion().majorVersion >= MixboxIosVersions.Supported.iOS14.majorVersion {
            return try TccDb_iOS_from_14(path: path)
        } else {
            return try TccDb_iOS_from_10_to_13(path: path)
        }
    }
}
