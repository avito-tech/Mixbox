import Foundation

// Defines how the element existance check polls for the element
public enum PollingConfiguration {
    // polls constantly without any pauses, consumes more CPU, finds element faster
    case reduceLatency
    // polls from time to time with pauses in between, consumes less CPU, finds element slower
    case reduceWorkload
}
