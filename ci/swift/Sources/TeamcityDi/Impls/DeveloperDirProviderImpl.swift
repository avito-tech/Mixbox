import Emcee
import DeveloperDirLocatorModels

public final class DeveloperDirProviderImpl: DeveloperDirProvider {
    private let xcodeCFBundleShortVersionString: String
    
    public init(xcodeCFBundleShortVersionString: String) {
        self.xcodeCFBundleShortVersionString = xcodeCFBundleShortVersionString
    }
    
    public func developerDir() throws -> DeveloperDir {
        return .useXcode(CFBundleShortVersionString: xcodeCFBundleShortVersionString)
    }
}
