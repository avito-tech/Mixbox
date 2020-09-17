import UIKit
import MixboxFoundation

final class PermissionsTestsView: TestStackScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    func setUpViews() {
        // TODO: Reset views
        
        let infos: [PermissionInfo] = [
            PhotosPermissionInfo(),
            GeolocationPermissionInfo(),
            CameraPermissionInfo(),
            MicrophonePermissionInfo(),
            NotificationsPermissionInfo()
        ]
        
        for info in infos {
            addLabel(id: info.identifier()) {
                let status = info.authorizationStatus()
                $0.text = "\(info.identifier()): \(status)"
                $0.mb_testability_customValues["authorizationStatus"] = status
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
