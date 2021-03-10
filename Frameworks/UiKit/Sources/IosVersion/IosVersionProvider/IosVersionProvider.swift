#if MIXBOX_ENABLE_IN_APP_SERVICES

// Examples:
//
// if iosVersionProvider.iosVersion() <= 7 { // iOS 6, iOS 7, iOS 7.1 suits
//
// switch iosVersionProvider.iosVersion() {
// case 6: break // iOS 6 suits
// case 7..<9: break // iOS 7, iOS 8, iOS 8.1 suits
// case 9...10.1: break // iOS 9, iOS 10, iOS 10.1 suits
// default: break
// }

public protocol IosVersionProvider {
    func iosVersion() -> IosVersion
}

#endif
