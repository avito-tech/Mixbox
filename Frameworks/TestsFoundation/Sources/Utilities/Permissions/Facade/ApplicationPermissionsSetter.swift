import MixboxFoundation

// Nice facade for setting up permissions in tests. E.g.:
//
//  func test() {
//      permissions.geolocation.set(.allowed)
//      permissions.camera.set(.notDetermined)
//  }
//
// Q&A: The reasons of methods instead of vars:
// 1. #file, #line
// 2. We only need setters
//
// Q&A: The reason of absence of `bundleId` in this facade:
// 1. It makes code look better, and we can still use different instances of this facade for different bundle ids. (see below)
// 2. Some permissions require other info (such as display name for setting notifications permissions in XCUI tests)
//
// So specific implementation of setting some permission should be shipped with a specific implementation of
// making `ApplicationPermissionsSetter` for a specific implementation of app.
//
// Q&A: If you want to test multiple apps, use something like this:
//
//  //  func permissions(_ someClass: SomeClass) -> ApplicationPermissionsSetter  {
//  //      return make(someClass.someArgsSuchAsBundleId)
//  //  }
//  permissions(mainApp).geolocation.set(.allowed)
//
//  //  class SomeFacadeForAllApps {
//  //      var mainApp: ApplicationPermissionsSetter {
//  //          return make(someArgsSuchAsBundleId)
//  //      }
//  // }
//  permissions.mainApp.geolocation.set(.allowed)
//

public protocol ApplicationPermissionsSetter: class {
    // TODO: Try to implement notDetermined for notifications
    var notifications: ApplicationPermissionWithoutNotDeterminedStateSetter  { get }
    
    var geolocation: ApplicationPermissionSetter { get }
    var calendar: ApplicationPermissionSetter { get }
    var camera: ApplicationPermissionSetter { get }
    var mso: ApplicationPermissionSetter { get }
    var mediaLibrary: ApplicationPermissionSetter { get }
    var microphone: ApplicationPermissionSetter { get }
    var motion: ApplicationPermissionSetter { get }
    var photos: ApplicationPermissionSetter { get }
    var reminders: ApplicationPermissionSetter { get }
    var siri: ApplicationPermissionSetter { get }
    var willow: ApplicationPermissionSetter { get }
    var addressBook: ApplicationPermissionSetter { get }
    var bluetoothPeripheral: ApplicationPermissionSetter { get }
    var calls: ApplicationPermissionSetter { get }
    var facebook: ApplicationPermissionSetter { get }
    var keyboardNetwork: ApplicationPermissionSetter { get }
    var liverpool: ApplicationPermissionSetter { get }
    var shareKit: ApplicationPermissionSetter { get }
    var sinaWeibo: ApplicationPermissionSetter { get }
    var speechRecognition: ApplicationPermissionSetter { get }
    var tencentWeibo: ApplicationPermissionSetter { get }
    var twitter: ApplicationPermissionSetter { get }
    var ubiquity: ApplicationPermissionSetter { get }
}
