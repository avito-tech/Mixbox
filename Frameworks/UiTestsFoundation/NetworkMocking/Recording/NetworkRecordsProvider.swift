public protocol NetworkRecordsProvider: class {
    var allRequests: [MonitoredNetworkRequest] { get }
}

extension NetworkRecordsProvider {
    public func lastRequest(urlPattern: String)
        -> MonitoredNetworkRequest?
    {
        return filter(urlPattern: urlPattern).last
    }
    
    public func filter(urlPattern: String) -> [MonitoredNetworkRequest] {
        guard let regex = try? NSRegularExpression(pattern: urlPattern, options: []) else {
            return [] // TODO: Fail test
        }
        
        return allRequests.filter {
            $0.urlMatches(regex: regex)
        }
    }
}

extension MonitoredNetworkRequest {
    public func queryItem(name: String) -> URLQueryItem? {
        guard let requestUrl = originalRequest?.url?.absoluteString,
            let components = URLComponents(string: requestUrl) else {
                return nil
        }
        return components.queryItems?.first { queryItem in
            queryItem.name == name
        }
    }
    
    public func urlMatches(regex: NSRegularExpression) -> Bool {
        // SBTUITestTunnel matches `request?.url?.absoluteString`, we match same.
        guard let absoluteString = originalRequest?.url?.absoluteString else {
            return false
        }
        
        let firstMatch = regex.firstMatch(
            in: absoluteString,
            range: NSRange(location: 0, length: (absoluteString as NSString).length)
        )
        
        return firstMatch != nil
    }
}
