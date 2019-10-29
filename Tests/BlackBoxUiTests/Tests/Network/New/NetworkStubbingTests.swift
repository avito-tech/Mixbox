import MixboxIpcCommon
import MixboxUiTestsFoundation
import XCTest

// TODO: BlackBox tests
// TODO: Make stubbing work before app is started! Check both cases.
// TODO: IMPORTANT: Check stubbing when files were not added to target.
//       I didn't add it, failure handling was poor and it took me a lot of time to figure it out.
//       NOTE: It was with GrayBoxLegacyNetworkStubbing which is not tested at the moment.
final class NetworkStubbingTests: BaseNetworkMockingTestCase {
    func test() {
        let compoundBridgedUrlProtocolClass = CompoundBridgedUrlProtocolClass()
        
        let instancesRepository = IpcObjectRepositoryImpl<BridgedUrlProtocolInstance & IpcObjectIdentifiable>()
        let classesRepository = IpcObjectRepositoryImpl<BridgedUrlProtocolClass & IpcObjectIdentifiable>()
        
        openScreen(
            name: screen.viewName
        )
        
        let networkStubber = UrlProtocolStubAdderImpl(
            bridgedUrlProtocolRegisterer: IpcBridgedUrlProtocolRegisterer(
                ipcClient: dependencies.resolve(),
                writeableClassesRepository: classesRepository.toStorable()
            ),
            rootBridgedUrlProtocolClass: compoundBridgedUrlProtocolClass,
            bridgedUrlProtocolClassRepository: compoundBridgedUrlProtocolClass,
            ipcRouterProvider: dependencies.resolve(),
            ipcMethodHandlersRegisterer: NetworkMockingIpcMethodsRegisterer(
                readableInstancesRepository: instancesRepository.toStorable { $0 },
                writeableInstancesRepository: instancesRepository.toStorable(),
                readableClassesRepository: classesRepository.toStorable { $0 },
                ipcClient: dependencies.resolve()
            )
        )
        
        do {
            _ = try networkStubber.addStub(
                bridgedUrlProtocolClass: TestBridgedUrlProtocolClass()
            )
        } catch {
            XCTFail("Failed to `addStub`: \(error)")
        }
        
        screen.exampleCom.tap()
        
        screen.info.assertHasText("Hello, world!")
    }
}

class TestBridgedUrlProtocolClass: BridgedUrlProtocolClass {
    func canInit(with request: BridgedUrlRequest) throws -> Bool {
        return true
    }
    
    func canonicalRequest(for request: BridgedUrlRequest) throws -> BridgedUrlRequest {
        return request
    }
    
    func requestIsCacheEquivalent(_ a: BridgedUrlRequest, to b: BridgedUrlRequest) throws -> Bool {
        return false
    }
    
    func createInstance(
        request: BridgedUrlRequest,
        cachedResponse: BridgedCachedUrlResponse?,
        client: BridgedUrlProtocolClient & IpcObjectIdentifiable)
        throws
        -> BridgedUrlProtocolInstance & IpcObjectIdentifiable
    {
        return TestBridgedUrlProtocolInstance(
            request: request,
            cachedResponse: cachedResponse,
            client: client
        )
    }
}

class TestBridgedUrlProtocolInstance: BridgedUrlProtocolInstance, IpcObjectIdentifiable {
    let ipcObjectId: IpcObjectId = .uuid
    
    private let request: BridgedUrlRequest
    private let cachedResponse: BridgedCachedUrlResponse?
    private let client: BridgedUrlProtocolClient
    
    init(
        request: BridgedUrlRequest,
        cachedResponse: BridgedCachedUrlResponse?,
        client: BridgedUrlProtocolClient)
    {
        self.request = request
        self.cachedResponse = cachedResponse
        self.client = client
    }
    
    func startLoading() throws {
        let response = BridgedUrlResponse(
            url: request.url,
            variation: .bare(
                BareURLResponseVariation(
                    mimeType: nil,
                    expectedContentLength: -1,
                    textEncodingName: nil
                )
            )
        )
        
        try client.urlProtocolDidReceive(
            response: response,
            cacheStoragePolicy: .notAllowed
        )
        
        try client.urlProtocolDidLoad(data: "Hello, world!".data(using: .utf8) ?? Data())
        
        try client.urlProtocolDidFinishLoading()
    }
    
    func stopLoading() throws {
    }
}
