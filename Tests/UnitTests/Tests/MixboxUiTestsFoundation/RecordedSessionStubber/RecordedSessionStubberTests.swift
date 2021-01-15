import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation
import XCTest
import MixboxIpcCommon
import MixboxMocksRuntime

final class RecordedSessionStubberTests: TestCase {
    private let stubResponseBuilder = MockStubResponseBuilder()
    private let legacyNetworkStubbing = MockLegacyNetworkStubbing()
    private lazy var recordedSessionStubber = RecordedSessionStubberImpl(
        legacyNetworkStubbing: legacyNetworkStubbing
    )
    
    override func setUp() {
        super.setUp()
        
        legacyNetworkStubbing
            .stub()
            .withRequestStub()
            .thenReturn(stubResponseBuilder)
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
            
            legacyNetworkStubbing.verify().withRequestStub(
                urlPattern: regexIsMatchedBy(actualUrl),
                httpMethod: equals(.put)
            ).isCalled()
            
            stubResponseBuilder.verify().withResponse(
                value: isDataThatIsJson(["data_key": "data_value"]),
                variation: equals(
                    .http(
                        HTTPURLResponseVariation(
                            headers: ["headers_key": "headers_value"],
                            statusCode: 418
                        )
                    )
                ),
                responseTime: equals(0)
            ).isCalled()
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
            
            legacyNetworkStubbing.verify().withRequestStub(
                urlPattern: regexIsMatchedBy(actualUrl),
                httpMethod: equals(.get)
            ).isCalled()
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

private func isDataThatIsJson(_ json: [String: Any]) -> Matcher<StubResponseBuilderResponseValue> {
    return Matcher<StubResponseBuilderResponseValue>(
        description: { "Response is of type `.data` and contains json \(json)" },
        matchingFunction: { value in
            do {
                switch value {
                case .data(let data):
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    guard let jsonObjectAsDictionary = jsonObject as? NSDictionary else {
                        throw ErrorString("JSON object is not dictionary")
                    }
                    
                    guard jsonObjectAsDictionary.isEqual(to: json) else {
                        throw ErrorString("JSON '\(jsonObjectAsDictionary)' is not equal to expected JSON '\(json)'")
                    }
                    
                    return .match
                case .string:
                    throw ErrorString("Value is .string")
                case .file:
                    throw ErrorString("Value is .file")
                }
            } catch {
                return .exactMismatch(
                    mismatchDescription: { "\(error)" },
                    attachments: { [] }
                )
            }
        }
    )
}

private func regexIsMatchedBy(_ string: String) -> Matcher<String> {
    return Matcher<String>(
        description: { "String \(string) is matched with a given regex" },
        matchingFunction: { pattern in
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                
                let firstMatch = regex.firstMatch(
                    in: string,
                    range: NSRange(location: 0, length: (string as NSString).length)
                )
                
                if firstMatch != nil {
                    return .match
                } else {
                    throw ErrorString("\(string) is not matched by \(pattern)")
                }
            } catch {
                return .exactMismatch(
                    mismatchDescription: { "\(error)" },
                    attachments: { [] }
                )
            }
        }
    )
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
