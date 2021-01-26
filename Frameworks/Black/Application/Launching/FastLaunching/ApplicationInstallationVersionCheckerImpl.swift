import XCTest
import MixboxTestsFoundation

/// Can be used to not install app if it is already installed.
/// Hot to integrate to Xcode:
///
/// 1. Add this Run-script Post-action:
///
/// ```
/// # Build checksum
/// # This reduces app launch time on functional tests.
///
/// appPath="${CODESIGNING_FOLDER_PATH}"
/// buildVersionFileName="ApplicationInstallationVersionChecker.buildVersion"
///
/// buildVersionFilePath="$appPath/$buildVersionFileName"
///
/// # synchronous id, it is not needed if the proper id is calculated syncronously.
/// # but proper id is calculated slowly, so we put it in background (see below).
/// uuidgen > "$buildVersionFilePath"
///
/// # find checksum of all files. if app is not changed, checksum is not changed (even if rebuild occurs).
/// # it takes 1.5 seconds, so we put it in background. There is a theoretical chance that build version will be used before
/// # it is calculated, so we make a random one syncronously. In fact the tests (currently on 2018.08) start using this number 5-10 seconds after build is finished.
/// nohup bash -c "find \"$appPath\" -type f  -not -name \"$buildVersionFileName\" -print0|xargs -0 shasum|shasum > \"$buildVersionFilePath\"" &
/// ```
///
/// 2. Replace `ApplicationInstallationVersionChecker.buildVersion` with anything you like
///    or keep it as is. Pass same value to `init` of the current class.
///
/// 3. Example of usage:
///
/// ```
/// di.register(type: SBTUITunneledApplication.self) { di in
///     let applicationInstallationVersionChecker: ApplicationInstallationVersionChecker = try di.resolve()
///     let bundleIdProvider: BundleIdProvider = try di.resolve()
///     // TODO: Feature Toggles for tests
///     let installationOptimizationEnabled = true
///
///     let shouldInstallApplication = installationOptimizationEnabled
///         ? !applicationInstallationVersionChecker.sameVersionOfTestedApplicationIsAlreadyInstalled()
///         : true
///
///     return SBTUITunneledApplication(
///         bundleId: bundleIdProvider.bundleId,
///         shouldInstallApplication: shouldInstallApplication
///     )
/// }
/// ```
public final class ApplicationInstallationVersionCheckerImpl: ApplicationInstallationVersionChecker {
    private let builtApplicationBundleProvider: ApplicationBundleProvider
    private let installedApplicationBundleProvider: ApplicationBundleProvider
    private let buildVersionFilePathRelativeToBundle: String
    
    public init(
        builtApplicationBundleProvider: ApplicationBundleProvider,
        installedApplicationBundleProvider: ApplicationBundleProvider,
        buildVersionFilePathRelativeToBundle: String)
    {
        self.builtApplicationBundleProvider = builtApplicationBundleProvider
        self.installedApplicationBundleProvider = installedApplicationBundleProvider
        self.buildVersionFilePathRelativeToBundle = buildVersionFilePathRelativeToBundle
    }
    
    public func sameVersionOfTestedApplicationIsAlreadyInstalled() -> Bool {
        switch (builtApplicationVersion(), installedApplicationVersion()) {
        case let (.some(l), .some(r)):
            return l == r
        default:
            return false
        }
    }
    
    private func builtApplicationVersion() -> String? {
        return bundleVersion(applicationBundleProvider: builtApplicationBundleProvider)
    }
    
    private func installedApplicationVersion() -> String? {
        return bundleVersion(applicationBundleProvider: installedApplicationBundleProvider)
    }
    
    private func bundleVersion(applicationBundleProvider: ApplicationBundleProvider) -> String? {
        do {
            let path = try applicationBundleProvider.applicationBundle().bundlePath
            return try String(contentsOfFile: path.mb_appendingPathComponent(buildVersionFilePathRelativeToBundle))
        } catch {
            return nil
        }
    }
}
