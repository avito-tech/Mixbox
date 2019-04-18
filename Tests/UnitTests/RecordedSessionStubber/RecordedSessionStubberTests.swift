import MixboxUiTestsFoundation
import Cuckoo
import XCTest

final class RecordedSessionStubberTests: XCTestCase {
    private let stubResponseBuilder = MockStubResponseBuilder()
    private let stubRequestBuilder = MockStubRequestBuilder()
    private lazy var recordedSessionStubber = RecordedSessionStubberImpl(
        stubRequestBuilder: stubRequestBuilder
    )
    
    override func setUp() {
        stubRequestBuilder
            .getStubbingProxy()
            .withRequestStub(urlPattern: any(), query: any(), httpMethod: any())
            .thenReturn(stubResponseBuilder)
        
        stubResponseBuilder
            .getStubbingProxy()
            .withResponse(value: any(), headers: any(), statusCode: any(), responseTime: any())
            .thenDoNothing()
    }
    
    func test___with_empty_path() {
        assert(
            stubWithUrl: "http://example.com",
            willMatch: "http://example.com"
        )
    }
    
    func test___with_empty_path___backslash_at_end_makes_no_difference_0() {
        assert(
            stubWithUrl: "http://example.com/",
            willMatch: "http://example.com/"
        )
    }
    
    func test___with_empty_path___backslash_at_end_makes_no_difference_1() {
        assert(
            stubWithUrl: "http://example.com",
            willMatch: "http://example.com/"
        )
    }
    
    func test___with_empty_path___backslash_at_end_makes_no_difference_2() {
        assert(
            stubWithUrl: "http://example.com/",
            willMatch: "http://example.com"
        )
    }
    
    func test___with_empty_path___backslash_at_end_makes_no_difference_3() {
        assert(
            stubWithUrl: "http://example.com",
            willMatch: "http://example.com"
        )
    }
    
    func test___with_empty_path___scheme_makes_no_difference() {
        assert(
            stubWithUrl: "http://example.com",
            willMatch: "https//example.com"
        )
    }
    
    func test___with_path___backslash_at_end_makes_no_difference_0() {
        assert(
            stubWithUrl: "http://example.com/path",
            willMatch: "https//example.com/path/"
        )
    }
    
    func test___with_path___backslash_at_end_makes_no_difference_1() {
        assert(
            stubWithUrl: "http://example.com/path/",
            willMatch: "https//example.com/path/"
        )
    }
    
    func test___with_path___backslash_at_end_makes_no_difference_2() {
        assert(
            stubWithUrl: "http://example.com/path/",
            willMatch: "https//example.com/path"
        )
    }
    
    func test___with_path___backslash_at_end_makes_no_difference_3() {
        assert(
            stubWithUrl: "http://example.com/path",
            willMatch: "https//example.com/path"
        )
    }
    
    func assert(
        stubWithUrl stubUrl: String,
        willMatch actualUrl: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        assertNoThrow {
            try recordedSessionStubber.stub(recordedStub: .withUrl(stubUrl))
            
            verify(stubRequestBuilder, file: file, line: line).withRequestStub(
                urlPattern: regexIsMatchedBy(actualUrl),
                query: equal(to: nil),
                httpMethod: equal(to: .get)
            )
        }
    }
    
    private func assertNoThrow(body: () throws -> ()) {
        do {
            try body()
        } catch let error {
            XCTFail("Code was expected to not throw error but it threw: \(error)")
        }
    }
}

public func regexIsMatchedBy(_ string: String) -> ParameterMatcher<String> {
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
