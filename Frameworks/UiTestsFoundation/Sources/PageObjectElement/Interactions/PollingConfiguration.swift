import Foundation

// Defines how the element existance check polls for the element
public final class PollingConfiguration {
    public let pollingTimeInterval: TimeInterval
    
    public init(pollingTimeInterval: TimeInterval) {
        self.pollingTimeInterval = pollingTimeInterval
    }
    
    // Consumes more CPU, finds element faster.
    //
    // Note: we still may want time interval greater than zero, because
    // we want to allow application to execute run loop, otherwise app may
    // lag and don't update UI and tests will lag too.
    //
    // Note: the value 0.1 was set in July 2023, before that it was 0 and app was lagging.
    public static var reduceLatency: PollingConfiguration {
        return PollingConfiguration(
            pollingTimeInterval: 0.1
        )
    }
    
    // Consumes less CPU, finds element slower
    //
    // Note: the value 1.0 worked fine for several years (since about 2018)
    // https://github.com/avito-tech/Mixbox/blob/db3206c95b71f35ae6032ff9b0baff13026608f4/Frameworks/XcuiDriver/Interactions/Interaction/Common/Parts/InteractionHelper.swift#L356
    public static var reduceWorkload: PollingConfiguration {
        return PollingConfiguration(
            pollingTimeInterval: 1.0
        )
    }
}
