import AVFoundation

final class MicrophonePermissionInfo: AvCaptureDevicePermissionInfo {
    init() {
        super.init(
            mediaType: .audio,
            identifier: "microphone"
        )
    }
}
