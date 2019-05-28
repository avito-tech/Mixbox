// To suppress warning when linting podspec
#if MIXBOX_CI_IS_LINTING_PODSPECS

import Foundation
import XCTest

open class SBTUITunneledApplication : XCUIApplication {
    open func launchTunnel() {}
    open func launchTunnel(startupBlock: (() -> Void)? = nil) {}
    open func launchTunnel(withOptions options: [String], startupBlock: (() -> Void)? = nil) {}
    open func launchConnectionless(_ command: @escaping (String, [String : String]) -> String) {}
    open class func setConnectionTimeout(_ timeout: TimeInterval) {}
    open func quit() {}
    open func stubRequests(matching match: SBTRequestMatch, response: SBTStubResponse) -> String? { return nil }
    open func stubRequests(matching match: SBTRequestMatch, response: SBTStubResponse, removeAfterIterations iterations: UInt) -> String? { return nil }
    open func stubRequestsRemove(withId stubId: String) -> Bool { return false }
    open func stubRequestsRemove(withIds stubIds: [String]) -> Bool { return false }
    open func stubRequestsRemoveAll() -> Bool { return false }
    open func rewriteRequests(matching match: SBTRequestMatch, rewrite: SBTRewrite) -> String? { return nil }
    open func rewriteRequests(matching match: SBTRequestMatch, rewrite: SBTRewrite, removeAfterIterations iterations: UInt) -> String? { return nil }
    open func rewriteRequestsRemove(withId rewriteId: String) -> Bool { return false }
    open func rewriteRequestsRemove(withIds rewriteIds: [String]) -> Bool { return false }
    open func rewriteRequestsRemoveAll() -> Bool { return false }
    open func monitorRequests(matching match: SBTRequestMatch) -> String? { return nil }
    open func monitoredRequestsPeekAll() -> [SBTMonitoredNetworkRequest] { return [] }
    open func monitoredRequestsFlushAll() -> [SBTMonitoredNetworkRequest] { return [] }
    open func monitorRequestRemove(withId reqId: String) -> Bool { return false }
    open func monitorRequestRemove(withIds reqIds: [String]) -> Bool { return false }
    open func monitorRequestRemoveAll() -> Bool { return false }
    open func waitForMonitoredRequests(matching match: SBTRequestMatch, timeout: TimeInterval) -> Bool { return false }
    open func waitForMonitoredRequests(matching match: SBTRequestMatch, timeout: TimeInterval, iterations: UInt) -> Bool { return false }
    open func throttleRequests(matching match: SBTRequestMatch, responseTime: TimeInterval) -> String? { return nil }
    open func throttleRequestRemove(withId reqId: String) -> Bool { return false }
    open func throttleRequestRemove(withIds reqIds: [String]) -> Bool { return false }
    open func throttleRequestRemoveAll() -> Bool { return false }
    open func blockCookiesInRequests(matching match: SBTRequestMatch) -> String? { return nil }
    open func blockCookiesInRequests(matching match: SBTRequestMatch, iterations: UInt) -> String? { return nil }
    open func blockCookiesRequestsRemove(withId reqId: String) -> Bool { return false }
    open func blockCookiesRequestsRemove(withIds reqIds: [String]) -> Bool { return false }
    open func blockCookiesRequestsRemoveAll() -> Bool { return false }
    open func userDefaultsSetObject(_ object: NSCoding, forKey key: String) -> Bool { return false }
    open func userDefaultsRemoveObject(forKey key: String) -> Bool { return false }
    open func userDefaultsObject(forKey key: String) -> Any? { return nil }
    open func userDefaultsReset() -> Bool { return false }
    open func userDefaultsSetObject(_ object: NSCoding, forKey key: String, suiteName: String) -> Bool { return false }
    open func userDefaultsRemoveObject(forKey key: String, suiteName: String) -> Bool { return false }
    open func userDefaultsObject(forKey key: String, suiteName: String) -> Any? { return nil }
    open func userDefaultsResetSuiteName(_ suiteName: String) -> Bool { return false }
    open func mainBundleInfoDictionary() -> [String : Any]? { return nil }
    open func uploadItem(atPath srcPath: String, toPath destPath: String?, relativeTo baseFolder: FileManager.SearchPathDirectory) -> Bool { return false }
    open func downloadItems(fromPath path: String, relativeTo baseFolder: FileManager.SearchPathDirectory) -> [Data]? { return nil }
    open func performCustomCommandNamed(_ commandName: String, object: Any?) -> Any? { return nil }
    open func setUserInterfaceAnimationsEnabled(_ enabled: Bool) -> Bool { return false }
    open func userInterfaceAnimationsEnabled() -> Bool { return false }
    open func setUserInterfaceAnimationSpeed(_ speed: Int) -> Bool { return false }
    open func userInterfaceAnimationSpeed() -> Int { return 0 }
}

open class SBTRequestMatch : NSObject/*, NSCoding*/ {
    open var url: String? { return nil }
    open var query: [String]? { return nil }
    open var method: String? { return nil }
    public init(url: String) {}
    public init(url: String, query: [String]) {}
    public init(url: String, query: [String], method: String) {}
    public init(url: String, method: String) {}
    public init(query: [String]) {}
    public init(query: [String], method: String) {}
    public init(method: String) {}
}

open class SBTMonitoredNetworkRequest : NSObject/*, NSCoding*/ {
    public override init() {}
    open func responseString() -> String? { return nil }
    open func responseJSON() -> Any? { return nil }
    open func requestString() -> String? { return nil }
    open func requestJSON() -> Any? { return nil }
    open func matches(_ match: SBTRequestMatch) -> Bool { return false }
    open var timestamp: TimeInterval { return 0 }
    open var requestTime: TimeInterval { return 0 }
    open var request: URLRequest? { return nil }
    open var originalRequest: URLRequest? { return nil }
    open var response: HTTPURLResponse? { return nil }
    open var responseData: Data? { return nil }
    open var isStubbed: Bool { return false }
    open var isRewritten: Bool { return false }
}

open class SBTRewriteReplacement : NSObject/*, NSCoding*/ {
    public init(find: String, replace: String) {}
    open func replace(_ string: String) -> String { return "" }
}

open class SBTRewrite : NSObject/*, NSCoding*/ {
    public convenience init(responseReplacement: [SBTRewriteReplacement], headersReplacement responseHeadersReplacement: [String : String], responseCode: Int) { self.init() }
    public convenience init(responseReplacement: [SBTRewriteReplacement], headersReplacement responseHeadersReplacement: [String : String]) { self.init() }
    public convenience init(responseReplacement: [SBTRewriteReplacement]) { self.init() }
    public convenience init(responseHeadersReplacement: [String : String]) { self.init() }
    public convenience init(responseStatusCode statusCode: Int) { self.init() }
    public convenience init(requestReplacement: [SBTRewriteReplacement], requestHeadersReplacement: [String : String]) { self.init() }
    public convenience init(requestReplacement: [SBTRewriteReplacement]) { self.init() }
    public convenience init(requestHeadersReplacement: [String : String]) { self.init() }
    public convenience init(requestUrlReplacement urlReplacement: [SBTRewriteReplacement]) { self.init() }
    public convenience init(urlReplacement: [SBTRewriteReplacement]?, requestReplacement: [SBTRewriteReplacement]?, requestHeadersReplacement: [String : String]?, responseReplacement: [SBTRewriteReplacement]?, responseHeadersReplacement: [String : String]?, responseCode: Int) { self.init() }
    public override init() {}
    open func rewrite(_ url: URL) -> URL { return URL(fileURLWithPath: "") }
    open func rewriteRequestHeaders(_ requestHeaders: [AnyHashable : Any]) -> [AnyHashable : Any] { return [:] }
    open func rewriteResponseHeaders(_ responseHeaders: [AnyHashable : Any]) -> [AnyHashable : Any] { return [:] }
    open func rewriteRequestBody(_ requestBody: Data) -> Data { return Data() }
    open func rewriteResponseBody(_ responseBody: Data) -> Data { return Data() }
    open func rewriteStatusCode(_ statusCode: Int) -> Int { return 0 }
}

open class SBTStubResponse : NSObject/*, NSCoding*/ {
    open class func failure(withCustomErrorCode code: Int, responseTime: TimeInterval) -> SBTStubResponse { return SBTStubResponse() }
    public override init() {}
    public convenience init(response: Any, headers: [String : String], contentType: String, returnCode: Int, responseTime: TimeInterval) { self.init() }
    public convenience init(response: Any) { self.init() }
    public convenience init(response: Any, responseTime: TimeInterval) { self.init() }
    public convenience init(response: Any, returnCode: Int) { self.init() }
    public convenience init(response: Any, returnCode: Int, responseTime: TimeInterval) { self.init() }
    public convenience init(response: Any, contentType: String, returnCode: Int) { self.init() }
    public convenience init(response: Any, headers: [String : String]?, returnCode: Int, responseTime: TimeInterval) { self.init() }
    public convenience init(fileNamed filename: String) { self.init() }
    public convenience init(fileNamed filename: String, responseTime: TimeInterval) { self.init() }
    public convenience init(fileNamed filename: String, returnCode: Int) { self.init() }
    public convenience init(fileNamed filename: String, returnCode: Int, responseTime: TimeInterval) { self.init() }
    public convenience init(fileNamed filename: String, headers: [String : String]?, returnCode: Int, responseTime: TimeInterval) { self.init() }
    
    open var data: Data { return Data() }
    open var contentType: String { return "" }
    open var headers: [AnyHashable : Any] { return [:] }
    open var returnCode: Int { return 0 }
    open var responseTime: TimeInterval { return 0 }
    open var failureCode: Int { return 0 }
    open class func setDefaultResponseTime(_ responseTime: TimeInterval) {}
    open class func setDefaultReturnCode(_ returnCode: Int) {}
    open class func setDictionaryDefaultContentType(_ contentType: String) {}
    open class func setDataDefaultContentType(_ contentType: String) {}
    open class func setStringDefaultContentType(_ contentType: String) {}
    open class func resetUnspecifiedDefaults() {}
}


#endif
