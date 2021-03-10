import MixboxTestsFoundation
import MixboxFoundation
import MixboxAnyCodable

final class RecordedStubFromMonitoredNetworkRequestConverter {
    private final class InternalError: Error {
        let request: MonitoredNetworkRequest
        let descriptionOfWhatRequestDoesntContain: String
        
        init(
            request: MonitoredNetworkRequest,
            descriptionOfWhatRequestDoesntContain: String)
        {
            self.request = request
            self.descriptionOfWhatRequestDoesntContain = descriptionOfWhatRequestDoesntContain
        }
    }

    private let testFailureRecorder: TestFailureRecorder
    
    init(testFailureRecorder: TestFailureRecorder) {
        self.testFailureRecorder = testFailureRecorder
    }
    
    func recordedStub(request: MonitoredNetworkRequest) -> RecordedStub? {
        do {
            let response = try getResponse(request: request)
            
            return RecordedStub(
                request: RecordedStubRequest(
                    url: try getUrl(request: request),
                    httpMethod: try getHttpMethod(request: request)
                ),
                response: RecordedStubResponse(
                    data: payload(
                        data: try getData(request: request)
                    ),
                    headers: try getAllHeaders(
                        request: request,
                        response: response
                    ),
                    statusCode: response.statusCode
                )
            )
        } catch let error as InternalError {
            handle(error: error)
            return nil
        } catch {
            handle(error: error)
            return nil
        }
    }
    
    private func payload(data: Data) -> RecordedStubResponseData {
        if let json = try? JSONDecoder().decode([String: AnyCodable].self, from: data) {
            return .json(json)
        } else {
            return .data(data)
        }
    }
    
    private func getUrl(request: MonitoredNetworkRequest) throws -> URL {
        guard let url = request.originalRequest?.url else {
            throw InternalError(
                request: request,
                descriptionOfWhatRequestDoesntContain: "originalRequest?.url"
            )
        }
        
        return url
    }
    
    private func getHttpMethod(request: MonitoredNetworkRequest) throws -> HttpMethod {
        guard let httpMethodString = request.originalRequest?.httpMethod else {
            throw InternalError(
                request: request,
                descriptionOfWhatRequestDoesntContain: "originalRequest?.httpMethod"
            )
        }
        
        guard let httpMethod = HttpMethod(rawValue: httpMethodString.lowercased()) else {
            throw ErrorString("originalRequest?.httpMethod value '\(httpMethodString)' is not supported in HttpMethod")
        }
        
        return httpMethod
    }
    
    private func getResponse(request: MonitoredNetworkRequest) throws -> HTTPURLResponse {
        guard let response = request.response else {
            throw InternalError(
                request: request,
                descriptionOfWhatRequestDoesntContain: "response"
            )
        }
        
        return response
    }
    
    private func getData(request: MonitoredNetworkRequest) throws -> Data {
        guard let data = request.responseData else {
            throw InternalError(
                request: request,
                descriptionOfWhatRequestDoesntContain: "responseData"
            )
        }
        
        return data
    }
    
    private func getAllHeaders(request: MonitoredNetworkRequest, response: HTTPURLResponse) throws -> [String: String] {
        guard let allHeaders = response.allHeaderFields as? [String: String] else {
            throw InternalError(
                request: request,
                descriptionOfWhatRequestDoesntContain: "response.allHeaderFields as? [String: String]"
            )
        }
        
        return allHeaders
    }
    
    private func handle(error: InternalError) {
        testFailureRecorder.recordMixboxInternalFailure(
            description: "Unexpected situation: request \(error.request) doesn't contain \(error.descriptionOfWhatRequestDoesntContain). TODO: Handle this situation properly.",
            shouldContinueTest: true
        )
    }
    
    private func handle(error: Error) {
        testFailureRecorder.recordMixboxInternalFailure(
            description: "Unexpected error: \(error). TODO: Handle this situation properly.",
            shouldContinueTest: true
        )
    }
}
