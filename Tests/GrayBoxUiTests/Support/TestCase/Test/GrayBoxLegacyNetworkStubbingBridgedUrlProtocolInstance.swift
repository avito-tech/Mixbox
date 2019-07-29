import MixboxUiTestsFoundation
import MixboxIpcCommon
import MixboxFoundation

class GrayBoxLegacyNetworkStubbingBridgedUrlProtocolInstance: BridgedUrlProtocolInstance, IpcObjectIdentifiable {
    let ipcObjectId: IpcObjectId = .uuid
    
    private let request: BridgedUrlRequest
    private let cachedResponse: BridgedCachedUrlResponse?
    private let client: BridgedUrlProtocolClient
    private let stub: GrayBoxLegacyNetworkStubbingNetworkStub
    
    init(
        request: BridgedUrlRequest,
        cachedResponse: BridgedCachedUrlResponse?,
        client: BridgedUrlProtocolClient,
        stub: GrayBoxLegacyNetworkStubbingNetworkStub)
    {
        self.request = request
        self.cachedResponse = cachedResponse
        self.client = client
        self.stub = stub
    }
    
    func startLoading() throws {
        let response = BridgedUrlResponse(
            url: request.url,
            mimeType: nil,
            expectedContentLength: -1,
            textEncodingName: nil
        )
        
        try client.urlProtocolDidReceive(
            response: response,
            cacheStoragePolicy: .notAllowed
        )
        
        try client.urlProtocolDidLoad(data: data())
        
        try client.urlProtocolDidFinishLoading()
    }
    
    func stopLoading() throws {
    }
    
    private func data() throws -> Data {
        switch stub.value {
        case .data(let data):
            return data
        case .string(let string):
            if let data = string.data(using: .utf8) {
                return data
            } else {
                throw ErrorString("string.data(using: .utf8) returned nil")
            }
        case .file(let string):
            return try Data(contentsOf: URL(fileURLWithPath: string))
        }
    }
}
