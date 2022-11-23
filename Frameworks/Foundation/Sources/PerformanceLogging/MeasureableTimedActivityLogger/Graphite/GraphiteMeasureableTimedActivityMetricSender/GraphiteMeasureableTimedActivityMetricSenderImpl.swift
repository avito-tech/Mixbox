#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class GraphiteMeasureableTimedActivityMetricSenderImpl:
    GraphiteMeasureableTimedActivityMetricSender,
    MeasureableTimedActivityMetricSenderWaiter
{
    private var steamWasOpened = false
    private lazy var invalidCharacterRegex = try? NSRegularExpression(pattern: "[^a-zA-Z0-9-_]", options: [])
    private let easyOutputStream: EasyOutputStream
    private let graphiteClient: GraphiteClient
    private let dispatchQueue = DispatchQueue(
        label: "GraphiteMeasureableTimedActivityMetricSenderImpl",
        qos: .background
    )
    private let prefix: [String]
    
    public init(
        easyOutputStream: EasyOutputStream,
        graphiteClient: GraphiteClient,
        prefix: [String])
    {
        self.easyOutputStream = easyOutputStream
        self.graphiteClient = graphiteClient
        self.prefix = prefix
    }
    
    public func send(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?),
        startDate: Date,
        stopDate: Date)
    {
        dispatchQueue.async { [weak self] in
            do {
                let strongSelf = try self.unwrapOrThrow()
                
                if !strongSelf.steamWasOpened {
                    try strongSelf.easyOutputStream.open()
                    strongSelf.steamWasOpened = true
                }
                
                let key = try strongSelf.replaceInvalidCharactersForGraphiteMetric(
                    string: dynamicName() ?? "\(staticName)"
                )
                
                try strongSelf.graphiteClient.send(
                    path: strongSelf.prefix + ["duration", key],
                    value: stopDate.timeIntervalSince(startDate),
                    timestamp: startDate
                )
            } catch {
                print("FIXME: Error")
            }
        }
    }
    
    public func waitForAllMetricsAreSent() {
        dispatchQueue.sync {}
    }

    private func replaceInvalidCharactersForGraphiteMetric(string: String) throws -> String {
        return try invalidCharacterRegex.unwrapOrThrow().stringByReplacingMatches(
            in: string,
            options: [],
            range: NSRange(location: 0, length: (string as NSString).length),
            withTemplate: "_"
        )
    }
}

#endif
