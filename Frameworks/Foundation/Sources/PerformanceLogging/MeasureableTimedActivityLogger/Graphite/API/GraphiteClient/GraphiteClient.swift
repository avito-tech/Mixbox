#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Dispatch
import Foundation

public final class GraphiteClient {
    private let easyOutputStream: EasyOutputStream
    
    public init(easyOutputStream: EasyOutputStream) {
        self.easyOutputStream = easyOutputStream
    }
    
    /// Sends a metric via provided stream.
    /// - Parameter path: graphite metric path components, e.g. `["domain", "subdomain", "metric"]`
    /// - Parameter value: a __finite__ double value for metric
    /// - Parameter timestamp: timestamp for metric value, e.g. `Date()`
    public func send(path: [String], value: Double, timestamp: Date) throws {
        let entry = try GraphiteMetric(path: path, value: value, timestamp: timestamp)
        try easyOutputStream.enqueueWrite(data: try data(metric: entry))
    }
    
    private func data(metric: GraphiteMetric) throws -> Data {
        let concatenatedMetricPath = GraphiteMetric.concatenated(path: metric.path)
        let graphiteMetricString = "\(concatenatedMetricPath) \(metric.value) \(UInt64(metric.timestamp.timeIntervalSince1970))\n"
        guard let data = graphiteMetricString.data(using: .utf8) else {
            throw GraphiteClientError.unableToGetData(from: graphiteMetricString)
        }
        return data
    }
}

#endif
