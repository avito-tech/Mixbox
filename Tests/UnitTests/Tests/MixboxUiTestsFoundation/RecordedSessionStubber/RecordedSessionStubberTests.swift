import MixboxUiTestsFoundation
import Cuckoo
import XCTest
import MixboxIpcCommon

final class RecordedSessionStubberTests: XCTestCase {
    private let stubResponseBuilder = MockStubResponseBuilder()
    private let stubRequestBuilder = MockStubRequestBuilder()
    private lazy var recordedSessionStubber = RecordedSessionStubberImpl(
        stubRequestBuilder: stubRequestBuilder
    )
    
    override func setUp() {
        super.setUp()
        
        stubRequestBuilder
            .getStubbingProxy()
            .withRequestStub(urlPattern: any(), httpMethod: any())
            .thenReturn(stubResponseBuilder)
        
        stubResponseBuilder
            .getStubbingProxy()
            .withResponse(
                value: any(),
                variation: any(),
                responseTime: any()
            )
            .thenDoNothing()
    }
    
    func test___with_empty_path() {
        assert(
            stubWithUrl: "http://example.com",
            willMatch: "http://example.com"
        )
    }
    
    func test___backslash_at_end_makes_no_difference___with_empty_path_0() {
        assert(
            stubWithUrl: "http://example.com/",
            willMatch: "http://example.com/"
        )
    }
    
    func test___backslash_at_end_makes_no_difference___with_empty_path_1() {
        assert(
            stubWithUrl: "http://example.com",
            willMatch: "http://example.com/"
        )
    }
    
    func test___backslash_at_end_makes_no_difference___with_empty_path_2() {
        assert(
            stubWithUrl: "http://example.com/",
            willMatch: "http://example.com"
        )
    }
    
    func test___backslash_at_end_makes_no_difference___with_empty_path_3() {
        assert(
            stubWithUrl: "http://example.com",
            willMatch: "http://example.com"
        )
    }
    
    func test___scheme_makes_no_difference___with_empty_path() {
        assert(
            stubWithUrl: "http://example.com",
            willMatch: "https://example.com"
        )
    }
    
    func test___backslash_at_end_makes_no_difference___with_path_0() {
        assert(
            stubWithUrl: "http://example.com/path",
            willMatch: "https://example.com/path/"
        )
    }
    
    func test___backslash_at_end_makes_no_difference___with_path_1() {
        assert(
            stubWithUrl: "http://example.com/path/",
            willMatch: "https://example.com/path/"
        )
    }
    
    func test___backslash_at_end_makes_no_difference___with_path_2() {
        assert(
            stubWithUrl: "http://example.com/path/",
            willMatch: "https://example.com/path"
        )
    }
    
    func test___backslash_at_end_makes_no_difference___with_path_3() {
        assert(
            stubWithUrl: "http://example.com/path",
            willMatch: "https://example.com/path"
        )
    }
    
    func test___port_makes_no_difference___with_path_0() {
        assert(
            stubWithUrl: "http://example.com:80/path",
            willMatch: "https://example.com/path"
        )
    }
    
    func test___port_makes_no_difference___with_path_1() {
        assert(
            stubWithUrl: "http://example.com/path",
            willMatch: "https://example.com:80/path"
        )
    }
    
    func test___port_makes_no_difference___with_path_2() {
        assert(
            stubWithUrl: "http://example.com:80/path",
            willMatch: "https://example.com:80/path"
        )
    }
    
    func test___port_makes_no_difference___with_empty_path_0() {
        assert(
            stubWithUrl: "http://example.com:80",
            willMatch: "https://example.com:80"
        )
    }
    
    func test___port_makes_no_difference___with_empty_path_1() {
        assert(
            stubWithUrl: "http://example.com",
            willMatch: "https://example.com:80"
        )
    }
    
    func test___port_makes_no_difference___with_empty_path_2() {
        assert(
            stubWithUrl: "http://example.com:80",
            willMatch: "https://example.com"
        )
    }
    
    func test___port_makes_no_difference___with_empty_path_3() {
        assert(
            stubWithUrl: "http://example.com:80/",
            willMatch: "https://example.com"
        )
    }
    
    func test___port_makes_no_difference___with_empty_path_4() {
        assert(
            stubWithUrl: "http://example.com:80",
            willMatch: "https://example.com/"
        )
    }
    
    func test___port_makes_no_difference___with_empty_path_5() {
        assert(
            stubWithUrl: "http://example.com:80",
            willMatch: "https://example.com/"
        )
    }
    
    func test___stub_is_stubbed_correctly() {
        assertNoThrow {
            let actualUrl = "http://qwerty.com/path/to/resource?query1=1&query2=2"
            
            try recordedSessionStubber.stub(
                recordedStub: RecordedStub(
                    request: RecordedStubRequest(
                        url: URL(string: actualUrl).unwrapOrFail(),
                        httpMethod: .put
                    ),
                    response: RecordedStubResponse(
                        data: .json(["data_key": "data_value"]),
                        headers: ["headers_key": "headers_value"],
                        statusCode: 418
                    )
                )
            )
            
            verify(stubRequestBuilder).withRequestStub(
                urlPattern: regexIsMatchedBy(actualUrl),
                httpMethod: equal(to: .put)
            )
            verify(stubResponseBuilder).withResponse(
                value: isDataThatIsJson(["data_key": "data_value"]),
                variation: equal(
                    to: .http(
                        HTTPURLResponseVariation(
                            headers: ["headers_key": "headers_value"],
                            statusCode: 418
                        )
                    )
                ),
                responseTime: 0
            )
        }
    }
    
    private func assert(
        stubWithUrl stubUrl: String,
        willMatch actualUrl: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        assertNoThrow {
            try recordedSessionStubber.stub(recordedStub: .withUrl(stubUrl))
            
            verify(stubRequestBuilder, file: file, line: line).withRequestStub(
                urlPattern: regexIsMatchedBy(actualUrl),
                httpMethod: equal(to: .get)
            )
        }
    }
    
    private func assertNoThrow(body: () throws -> ()) {
        do {
            try body()
        } catch {
            XCTFail("Code was expected to not throw error but it threw: \(error)")
        }
    }
}

private func isDataThatIsJson(_ json: [String: Any]) -> ParameterMatcher<StubResponseBuilderResponseValue> {
    return ParameterMatcher<StubResponseBuilderResponseValue> { value in
        switch value {
        case .data(let data):
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonObjectAsDictionary = jsonObject as? NSDictionary
            {
                return jsonObjectAsDictionary.isEqual(to: json)
            } else {
                return false
            }
        case .string:
            return false
        case .file:
            return false
        }
    }
}

private func regexIsMatchedBy(_ string: String) -> ParameterMatcher<String> {
    return ParameterMatcher<String> { pattern in
        let regex = (try? NSRegularExpression(pattern: pattern, options: [])).unwrapOrFail()
        
        let firstMatch = regex.firstMatch(
            in: string,
            range: NSRange(location: 0, length: (string as NSString).length)
        )
        
        return firstMatch != nil
    }
}

private extension RecordedStub {
    static func withUrl(_ string: String) -> RecordedStub {
        return RecordedStub(
            request: RecordedStubRequest(
                url: URL(string: string).unwrapOrFail(),
                httpMethod: .get
            ),
            response: RecordedStubResponse(
                data: .json([:]),
                headers: [:],
                statusCode: 200
            )
        )
    }
}
