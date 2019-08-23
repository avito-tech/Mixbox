#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public final class UrlResponseBridgingImpl: UrlResponseBridging {
    public init() {
    }
    
    public func bridgedUrlResponse(urlResponse: URLResponse) -> BridgedUrlResponse {
        if let httpResponse = urlResponse as? HTTPURLResponse {
            return BridgedUrlResponse(
                url: httpResponse.url,
                variation: .http(
                    headers: httpResponse.allHeaderFields
                        .reduce(into: [String: String]()) { headers, keyValue in
                            if let key = keyValue.key.base as? String,
                                let value = keyValue.value as? String {
                                headers[key] = value
                            }
                        },
                    statusCode: httpResponse.statusCode
                )
            )
        } else {
            return BridgedUrlResponse(
                url: urlResponse.url,
                variation: .bare(
                    mimeType: urlResponse.mimeType,
                    expectedContentLength: urlResponse.expectedContentLength,
                    textEncodingName: urlResponse.textEncodingName
                )
            )
        }
    }
    
    public func urlResponse(bridgedUrlResponse: BridgedUrlResponse) -> URLResponse {
        switch bridgedUrlResponse.variation {
        case let .bare(
            mimeType: mimeType,
            expectedContentLength: expectedContentLength,
            textEncodingName: textEncodingName):
            return UrlResponseWithFixedInit(
                url: bridgedUrlResponse.url,
                mimeType: mimeType,
                expectedContentLength: expectedContentLength,
                textEncodingName: textEncodingName
            )
        case let .http(
            headers: headers,
            statusCode: statusCode):
            return HTTPURLResponse(
                url: bridgedUrlResponse.url ?? UrlResponseBridgingImpl.urlThatHopefullyDoesntBreakAnything,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: headers
            ) ?? UrlResponseWithFixedInit(
                url: bridgedUrlResponse.url,
                mimeType: nil,
                expectedContentLength: -1,
                textEncodingName: nil
            )
        }
    }
    
    private static var urlThatHopefullyDoesntBreakAnything: URL {
        return URL(fileURLWithPath: "ThisUrlShouldntBeUsedAnywhereAndWasCreatedToWorkaroundOptionalityOfUrlInTheInitOfURLResponses")
    }
    
    private class UrlResponseWithFixedInit: URLResponse {
        private var urlPassedViaInit: URL?
        private var expectedContentLengthPassedViaInit: Int64
        
        override var url: URL? {
            return urlPassedViaInit
        }
        
        override var expectedContentLength: Int64 {
            return expectedContentLengthPassedViaInit
        }
        
        init(
            url: URL?,
            mimeType: String?,
            expectedContentLength: Int64,
            textEncodingName: String?)
        {
            urlPassedViaInit = url
            expectedContentLengthPassedViaInit = expectedContentLength
            
            super.init(
                url: url ?? UrlResponseBridgingImpl.urlThatHopefullyDoesntBreakAnything,
                mimeType: mimeType,
                expectedContentLength: Int(truncatingIfNeeded: expectedContentLength),
                textEncodingName: textEncodingName
            )
        }
        
        required init?(coder aDecoder: NSCoder) {
            urlPassedViaInit = UrlResponseBridgingImpl.urlThatHopefullyDoesntBreakAnything
            expectedContentLengthPassedViaInit = 0
            
            super.init(coder: aDecoder)
            
            urlPassedViaInit = super.url
            expectedContentLengthPassedViaInit = super.expectedContentLength
        }
    }
}

#endif
