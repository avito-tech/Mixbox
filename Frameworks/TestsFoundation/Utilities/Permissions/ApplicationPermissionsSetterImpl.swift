public final class ApplicationPermissionsSetterImpl: ApplicationPermissionsSetter {
    public let notifications: ApplicationPermissionWithoutNotDeterminedStateSetter
    public let geolocation: ApplicationPermissionSetter
    public let calendar: ApplicationPermissionSetter
    public let camera: ApplicationPermissionSetter
    public let mso: ApplicationPermissionSetter
    public let mediaLibrary: ApplicationPermissionSetter
    public let microphone: ApplicationPermissionSetter
    public let motion: ApplicationPermissionSetter
    public let photos: ApplicationPermissionSetter
    public let reminders: ApplicationPermissionSetter
    public let siri: ApplicationPermissionSetter
    public let willow: ApplicationPermissionSetter
    public let addressBook: ApplicationPermissionSetter
    public let bluetoothPeripheral: ApplicationPermissionSetter
    public let calls: ApplicationPermissionSetter
    public let facebook: ApplicationPermissionSetter
    public let keyboardNetwork: ApplicationPermissionSetter
    public let liverpool: ApplicationPermissionSetter
    public let shareKit: ApplicationPermissionSetter
    public let sinaWeibo: ApplicationPermissionSetter
    public let speechRecognition: ApplicationPermissionSetter
    public let tencentWeibo: ApplicationPermissionSetter
    public let twitter: ApplicationPermissionSetter
    public let ubiquity: ApplicationPermissionSetter
    
    public init(
        notifications: ApplicationPermissionWithoutNotDeterminedStateSetter,
        geolocation: ApplicationPermissionSetter,
        calendar: ApplicationPermissionSetter,
        camera: ApplicationPermissionSetter,
        mso: ApplicationPermissionSetter,
        mediaLibrary: ApplicationPermissionSetter,
        microphone: ApplicationPermissionSetter,
        motion: ApplicationPermissionSetter,
        photos: ApplicationPermissionSetter,
        reminders: ApplicationPermissionSetter,
        siri: ApplicationPermissionSetter,
        willow: ApplicationPermissionSetter,
        addressBook: ApplicationPermissionSetter,
        bluetoothPeripheral: ApplicationPermissionSetter,
        calls: ApplicationPermissionSetter,
        facebook: ApplicationPermissionSetter,
        keyboardNetwork: ApplicationPermissionSetter,
        liverpool: ApplicationPermissionSetter,
        shareKit: ApplicationPermissionSetter,
        sinaWeibo: ApplicationPermissionSetter,
        speechRecognition: ApplicationPermissionSetter,
        tencentWeibo: ApplicationPermissionSetter,
        twitter: ApplicationPermissionSetter,
        ubiquity: ApplicationPermissionSetter)
    {
        self.notifications = notifications
        self.geolocation = geolocation
        self.calendar = calendar
        self.camera = camera
        self.mso = mso
        self.mediaLibrary = mediaLibrary
        self.microphone = microphone
        self.motion = motion
        self.photos = photos
        self.reminders = reminders
        self.siri = siri
        self.willow = willow
        self.addressBook = addressBook
        self.bluetoothPeripheral = bluetoothPeripheral
        self.calls = calls
        self.facebook = facebook
        self.keyboardNetwork = keyboardNetwork
        self.liverpool = liverpool
        self.shareKit = shareKit
        self.sinaWeibo = sinaWeibo
        self.speechRecognition = speechRecognition
        self.tencentWeibo = tencentWeibo
        self.twitter = twitter
        self.ubiquity = ubiquity
    }
}
