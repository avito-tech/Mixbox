import MixboxFoundation

public protocol MockManager:
    MockManagerStubbing,
    MockManagerCalling,
    MockManagerVerification,
    MockManagerStateTransferring,
    MockedInstanceInfoSettable
{
}
