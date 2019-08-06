#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public final class UrlResponseBridgingImpl: UrlResponseBridging {
    public init() {
    }
    
    public func bridgedUrlResponse(urlResponse: URLResponse) -> BridgedUrlResponse {
        return BridgedUrlResponse(
            url: urlResponse.url,
            mimeType: urlResponse.mimeType,
            expectedContentLength: urlResponse.expectedContentLength,
            textEncodingName: urlResponse.textEncodingName
        )
    }
    
    public func urlResponse(bridgedUrlResponse: BridgedUrlResponse) -> URLResponse {
        return UrlResponseWithFixedInit(
            url: bridgedUrlResponse.url,
            mimeType: bridgedUrlResponse.mimeType,
            expectedContentLength: bridgedUrlResponse.expectedContentLength,
            textEncodingName: bridgedUrlResponse.textEncodingName
        )
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
        
        private static var urlThatHopefullyDoesntBreakAnything: URL {
            return URL(fileURLWithPath: "ThisUrlShouldntBeUsedAnywhereAndWasCreatedToWorkaroundOptionalityOfUrlInTheInitOfURLResponses")
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
                url: url ?? UrlResponseWithFixedInit.urlThatHopefullyDoesntBreakAnything,
                mimeType: mimeType,
                expectedContentLength: Int(truncatingIfNeeded: expectedContentLength),
                textEncodingName: textEncodingName
            )
        }
        
        required init?(coder aDecoder: NSCoder) {
            urlPassedViaInit = UrlResponseWithFixedInit.urlThatHopefullyDoesntBreakAnything
            expectedContentLengthPassedViaInit = 0
            
            super.init(coder: aDecoder)
            
            urlPassedViaInit = super.url
            expectedContentLengthPassedViaInit = super.expectedContentLength
        }
    }
}

#endif
