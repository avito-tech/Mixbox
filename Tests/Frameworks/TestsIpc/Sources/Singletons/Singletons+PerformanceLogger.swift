import MixboxFoundation

public extension Singletons {
    public static let performanceLogger = performanceLoggingRelatedClasses.logger
    public static let measureableTimedActivityMetricSenderWaiter = performanceLoggingRelatedClasses.waiter
    
    private static let performanceLoggingRelatedClasses = makePerformanceLoggingRelatedClasses()
    
    private static func makePerformanceLoggingRelatedClasses()
        -> (logger: PerformanceLogger, waiter: MeasureableTimedActivityMetricSenderWaiter)
    {
        let graphiteMeasureableTimedActivityMetricSender = makeGraphiteMeasureableTimedActivityMetricSender()
        
        let logger = PerformanceLoggerImpl(
            signpostMeasureableTimedActivityLogger: makeSignpostMeasureableTimedActivityLogger(),
            graphiteMeasureableTimedActivityLogger: makeGraphiteMeasureableTimedActivityLogger(
                graphiteMeasureableTimedActivityMetricSender: graphiteMeasureableTimedActivityMetricSender
            )
        )
        
        return (
            logger: logger,
            waiter: graphiteMeasureableTimedActivityMetricSender
                ?? NoopMeasureableTimedActivityMetricSenderWaiter()
        )
    }
    
    private static func makeSignpostMeasureableTimedActivityLogger() -> MeasureableTimedActivityLogger {
        if #available(iOS 12.0, *) {
            return SignpostMeasureableTimedActivityLogger(
                signpostLoggerFactory: SignpostLoggerFactoryImpl(),
                subsystem: "mixbox",
                category: "mixbox" // TODO: Find a use for it
            )
        } else {
            return NoopMeasureableTimedActivityLogger()
        }
    }
    
    private static func makeGraphiteMeasureableTimedActivityMetricSender()
        -> (GraphiteMeasureableTimedActivityMetricSender & MeasureableTimedActivityMetricSenderWaiter)?
    {
        let environment = Singletons.environmentProvider.environment
        
        guard let host = environment["MIXBOX_CI_GRAPHITE_HOST"] else {
            return nil
        }
        
        guard let port = (environment["MIXBOX_CI_GRAPHITE_PORT"].flatMap { Int($0) }) else {
            return nil
        }
        
        guard let prefix = environment["MIXBOX_CI_GRAPHITE_PREFIX"] else {
            return nil
        }
        
        let easyOutputStream = EasyOutputStream(
            outputStreamProvider: NetworkSocketOutputStreamProvider(
                host: host,
                port: port
            ),
            errorHandler: { _, error in
                debugPrint("Graphite stream error: \(error)")
            },
            streamEndHandler: { _ in
                debugPrint("Graphite stream has been closed")
            }
        )
        
        return GraphiteMeasureableTimedActivityMetricSenderImpl(
            easyOutputStream: easyOutputStream,
            graphiteClient: GraphiteClient(
                easyOutputStream: easyOutputStream
            ),
            prefix: prefix.components(separatedBy: ".")
        )
    }
    
    private static func makeGraphiteMeasureableTimedActivityLogger(
        graphiteMeasureableTimedActivityMetricSender: GraphiteMeasureableTimedActivityMetricSender?)
        -> MeasureableTimedActivityLogger
    {
        guard let graphiteMeasureableTimedActivityMetricSender = graphiteMeasureableTimedActivityMetricSender else {
            return NoopMeasureableTimedActivityLogger()
        }
        
        return GraphiteMeasureableTimedActivityLogger(
            graphiteMeasureableTimedActivityMetricSender: graphiteMeasureableTimedActivityMetricSender,
            dateProvider: SystemClockDateProvider()
        )
    }
}
