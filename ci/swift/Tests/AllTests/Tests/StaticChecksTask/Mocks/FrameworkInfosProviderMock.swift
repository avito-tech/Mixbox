import StaticChecksTask

public final class FrameworkInfosProviderMock: FrameworkInfosProvider {
    private let stubbedFrameworkInfos: [FrameworkInfo]
    
    public init(frameworkInfos: [FrameworkInfo]) {
        self.stubbedFrameworkInfos = frameworkInfos
    }
    
    public func frameworkInfos() -> [FrameworkInfo] {
        return stubbedFrameworkInfos
    }
}
