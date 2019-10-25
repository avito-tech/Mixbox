import MixboxFoundation
import MixboxTestsFoundation

public final class ReplayingNetworkPlayer: NetworkPlayer {
    // Dependencies
    
    private let startOnceToken = ThreadUnsafeOnceToken<Void>()
    private let recordedNetworkSession: RecordedNetworkSession
    private let recordedSessionStubber: RecordedSessionStubber
    private let testFailureRecorder: TestFailureRecorder
    private let onStart: () -> ()
    
    // State
    
    private var bucketsLeftToStub = [RecordedStubBucket]()
    
    public init(
        recordedNetworkSession: RecordedNetworkSession,
        recordedSessionStubber: RecordedSessionStubber,
        testFailureRecorder: TestFailureRecorder,
        onStart: @escaping () -> ())
    {
        self.recordedNetworkSession = recordedNetworkSession
        self.recordedSessionStubber = recordedSessionStubber
        self.testFailureRecorder = testFailureRecorder
        self.onStart = onStart
    }
    
    public func checkpointImpl(
        id idOrNil: String?,
        fileLine: RuntimeFileLine)
    {
        guard let id = idOrNil else {
            failTestBecauseIdOfCheckpointWasNotSet()
            return
        }
        
        startOnce()
        stubNetworkForCurrentCheckpoint(id: id)
    }
    
    private func stubNetworkForCurrentCheckpoint(id: String) {
        validateCurrentBucket(idFromCallOfCheckpointFunction: id)
        
        bucketsLeftToStub = Array(bucketsLeftToStub.dropFirst())
        
        guard let bucketToStub = bucketsLeftToStub.first else {
            // A valid case if it is a last bucket.
            return
        }
        
        do {
            try bucketToStub.recordedStubs.forEach {
                try recordedSessionStubber.stub(recordedStub: $0)
            }
        } catch {
            testFailureRecorder.recordFailure(
                description: "Failed to stub bucket: \(error)",
                shouldContinueTest: false
            )
        }
    }
    
    private func validateCurrentBucket(idFromCallOfCheckpointFunction: String) {
        guard let first = bucketsLeftToStub.first else {
            failTestBecauseThereIsNoBucketsLeft()
            return
        }
        
        let idFromRecord = first.id
        
        guard idFromRecord == idFromCallOfCheckpointFunction else {
            failTestBecauseThereIdOfBucketsIsNotExpected(
                idFromRecord: idFromRecord,
                idFromCallOfCheckpointFunction: idFromCallOfCheckpointFunction
            )
            return
        }
    }
    
    private func failTestBecauseThereIsNoBucketsLeft() {
        testFailureRecorder.recordFailure(
            description: "Bucket with id wasn't found - no buckets left to stub. Did you add additional checkpoint and did not record bucket for it?",
            shouldContinueTest: false
        )
    }
    
    private func failTestBecauseThereIdOfBucketsIsNotExpected(
        idFromRecord: String,
        idFromCallOfCheckpointFunction: String)
    {
        testFailureRecorder.recordFailure(
            description: "Unexpected bucket id in recordedNetworkSession: \(idFromRecord). Expected bucket id (from source code  that calls `checkpoint`): \(idFromCallOfCheckpointFunction). Maybe recordedNetworkSession is outdated and you need to rerecord it. Example that produce this failure (pseudocode): you have checkpoints [A, B] in code and [A, C] in recordedNetworkSession JSON, in that case C is not expected, B is expected.",
            shouldContinueTest: false
        )
    }
    
    private func failTestBecauseIdOfCheckpointWasNotSet() {
        testFailureRecorder.recordFailure(
            description: "`id` wasn't specified in `checkpoint()` function (or in `checkpointImpl`, which I hope you didn't use directly). You can only skip setting id in recording mode (when file with records is empty). Please, remove all contents of file with records (but not the file) and retry.",
            shouldContinueTest: true
        )
    }
    
    private func startOnce() {
        _ = startOnceToken.executeOnce {
            start()
            onStart()
        }
    }
    
    private func start() {
        recordedSessionStubber.stubAllNetworkInitially()
        validateRecordedNetworkSession()
        bucketsLeftToStub = recordedNetworkSession.buckets
    }
    
    private func validateRecordedNetworkSession() {
        let set = NSCountedSet(array: recordedNetworkSession.buckets.map { $0.id })
        let duplicatedIds = set.filter { set.count(for: $0) > 1 }
        
        if !duplicatedIds.isEmpty {
            testFailureRecorder.recordFailure(
                description: "Found duplicated ids in recordedNetworkSession: \(duplicatedIds)",
                shouldContinueTest: false
            )
        }
    }
}
