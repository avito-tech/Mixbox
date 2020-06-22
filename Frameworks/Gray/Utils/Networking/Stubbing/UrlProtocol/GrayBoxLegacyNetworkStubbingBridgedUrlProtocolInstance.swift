import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxIpcCommon
import MixboxFoundation
import UIKit
import Foundation

public class GrayBoxLegacyNetworkStubbingBridgedUrlProtocolInstance: BridgedUrlProtocolInstance, IpcObjectIdentifiable {
    public let ipcObjectId: IpcObjectId = .uuid
    
    private let url: URL?
    private let client: BridgedUrlProtocolClient
    private let stub: GrayBoxLegacyNetworkStubbingNetworkStub
    private let bundleResourcePathProvider: BundleResourcePathProvider
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        url: URL?,
        client: BridgedUrlProtocolClient,
        stub: GrayBoxLegacyNetworkStubbingNetworkStub,
        bundleResourcePathProvider: BundleResourcePathProvider,
        testFailureRecorder: TestFailureRecorder)
    {
        self.url = url
        self.client = client
        self.stub = stub
        self.bundleResourcePathProvider = bundleResourcePathProvider
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func startLoading() throws {
        let response = BridgedUrlResponse(
            url: url,
            variation: stub.variation
        )
        
        try client.urlProtocolDidReceive(
            response: response,
            cacheStoragePolicy: .notAllowed
        )
        
        try client.urlProtocolDidLoad(data: data())
        
        try client.urlProtocolDidFinishLoading()
    }
    
    public func stopLoading() throws {
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
            do {
                let path = try bundleResourcePathProvider.path(resource: string)
                return try Data(contentsOf: URL(fileURLWithPath: path))
            } catch {
                testFailureRecorder.recordFailure(
                    description: "Failed to load file \(string) from \(bundleResourcePathProvider)`: \(error)",
                    fileLine: .current(),
                    shouldContinueTest: false
                )
                throw error
            }
        }
    }
}
