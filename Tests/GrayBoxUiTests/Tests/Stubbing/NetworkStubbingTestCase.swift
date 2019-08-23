import XCTest
import MixboxIpcCommon

final class NetworkStubbingTestCase: TestCase {
    
    func testBareStubingReturnsURLResponse() {
        legacyNetworking.stubbing
            .stub(urlPattern: ".*")
            .thenReturn(
                data: Data(),
                mimeType: "image/jpeg",
                expectedContentLength: 100500,
                textEncodingName: nil
            )
        
        guard let url = URL(string: "google.com") else { return XCTFail("Can't make URL") }
    
        let expectation = XCTestExpectation(description: "URLSession stub expectation")
        URLSession.shared.dataTask(with: url) { _, response, _ in
            XCTAssertEqual(
                response?.mimeType,
                "image/jpeg"
            )
            XCTAssertFalse(response is HTTPURLResponse)
            expectation.fulfill()
        }.resume()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testHTTPStubingReturnsHTTPURLResponse() {
        legacyNetworking.stubbing
            .stub(urlPattern: ".*")
            .thenReturn(
                data: Data(),
                headers: ["Content-Type": "image/jpeg"],
                statusCode: 200
            )
        
        guard let url = URL(string: "google.com") else { return XCTFail("Can't make URL") }
        
        let expectation = XCTestExpectation(description: "URLSession stub expectation")
        URLSession.shared.dataTask(with: url) { _, response, _ in
            guard let response = response as? HTTPURLResponse else {
                return XCTFail("Response with headers and status code is expected to be HTTPURLResponse")
            }
            XCTAssertEqual(
                response.allHeaderFields[AnyHashable("Content-Type")] as? String,
                "image/jpeg"
            )
            expectation.fulfill()
        }.resume()
        
        wait(for: [expectation], timeout: 5)
    }
    
}
