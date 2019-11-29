import AVFoundation

class AvCaptureDevicePermissionInfo: PermissionInfo {
    private let mediaType: AVMediaType
    private let _identifier: String
    
    // NOTE: If you use these args and request authorizationStatus, it will raise exception on iOS Simulator:
    // AvCaptureDevicePermissionInfo(mediaType: .text, identifier: "text"),
    // AvCaptureDevicePermissionInfo(mediaType: .closedCaption, identifier: "closedCaption"),
    // AvCaptureDevicePermissionInfo(mediaType: .subtitle, identifier: "subtitle"),
    // AvCaptureDevicePermissionInfo(mediaType: .timecode, identifier: "timecode"),
    // AvCaptureDevicePermissionInfo(mediaType: .metadata, identifier: "metadata"),
    // AvCaptureDevicePermissionInfo(mediaType: .muxed, identifier: "muxed")
    init(mediaType: AVMediaType, identifier: String) {
        self.mediaType = mediaType
        self._identifier = identifier
    }
    
    func identifier() -> String {
        return _identifier
    }
    
    func authorizationStatus() -> String {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        switch status {
        case .authorized:
            return "authorized"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        @unknown default:
            return "UNKNOWN: \(status)"
        }
    }
}
