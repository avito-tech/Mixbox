import AVFoundation

final class CameraPermissionInfo: AvCaptureDevicePermissionInfo {
    init() {
        super.init(
            mediaType: .video,
            identifier: "camera"
        )
    }
}
