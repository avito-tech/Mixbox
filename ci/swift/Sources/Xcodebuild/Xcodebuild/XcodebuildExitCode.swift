// https://developer.apple.com/forums/thread/121458
public enum XcodebuildExitCode: Int {
    case successfulTermination = 0
    case commandLineUsageError = 64
    case dataFormatError = 65
    case cannotOpenInput = 66
    case addresseeUnknown = 67
    case hostNameUnknown = 68
    case serviceUnavailable = 69
    case internalSoftwareError = 70
    case systemError = 71 // (e.g., can't fork)
    case criticalOsFileMissing = 72
    case cantCreateOutputFile = 73
    case inputOutputError = 74
    case tempFailure = 75 // user is invited to retry
    case remoteErrorInProtocol = 76
    case permissionDenied = 77
    case configurationError = 78
}
