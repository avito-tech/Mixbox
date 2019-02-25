#if !MIXBOX_ENABLE_IN_APP_SERVICES

// To prevent this code to be inside your release version of app:
// 1. Define MIXBOX_ENABLE_IN_APP_SERVICES in Swift and Obj-C:
//      In GCC_PREPROCESSOR_DEFINITIONS: MIXBOX_ENABLE_IN_APP_SERVICES=1
//      In OTHER_SWIFT_FLAGS: -D MIXBOX_ENABLE_IN_APP_SERVICES
// 2. Do not link this module in your release configuration.
// 3. Do not forget to NOT define MIXBOX_ENABLE_IN_APP_SERVICES in your release configuration.
//
// Example for Cocoapods: See Demo project.
//
@_silgen_name("ItSeemsThatYouAreLinkingMixboxInAppServicesOutsideOfTestsSeeThisStringWithoutUnderscoreInCodeForComments")
private func functionThatIsCreatedJustToProduceErrorAtLinking()
private class UserOfFunctionThatIsCreatedJustToProduceErrorAtLinking {
    func userOfFunctionThatIsCreatedJustToProduceErrorAtLinking() {
        functionThatIsCreatedJustToProduceErrorAtLinking()
    }
}

#endif
