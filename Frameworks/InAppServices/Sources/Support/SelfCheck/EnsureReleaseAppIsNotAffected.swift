#if !MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && !MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES

// To prevent this code to be inside your release version of app:
// 1. Define MIXBOX_ENABLE_ALL_FRAMEWORKS in Swift and Obj-C:
//      In GCC_PREPROCESSOR_DEFINITIONS: MIXBOX_ENABLE_ALL_FRAMEWORKS=1
//      In OTHER_SWIFT_FLAGS: -D MIXBOX_ENABLE_ALL_FRAMEWORKS
// 2. Do not link this module in your release configuration.
// 3. Do not forget to NOT define MIXBOX_ENABLE_ALL_FRAMEWORKS in your release configuration.
//
// Example for Cocoapods: See demo project.
//
// TODO: Write test (in MixboxSwiftCI project), because it was broken once.
//
// This code makes not implemented function to fail build at linking stage.
@_silgen_name("ItSeemsThatYouAreLinkingMixboxInAppServicesOutsideOfTestsSeeThisStringWithoutUnderscoreInCodeForComments")
private func functionThatIsCreatedJustToProduceErrorAtLinking()

// This is to prevent symbol from stripping.
private class UserOfFunctionThatIsCreatedJustToProduceErrorAtLinking {
    func userOfFunctionThatIsCreatedJustToProduceErrorAtLinking() {
        functionThatIsCreatedJustToProduceErrorAtLinking()
    }
}

// Note: the #if clause at the beginning of file has this logic behind it:
// If a person did not define any of compilation flags, but uses this framework, they should be noticed that it's probably an error.

#endif
