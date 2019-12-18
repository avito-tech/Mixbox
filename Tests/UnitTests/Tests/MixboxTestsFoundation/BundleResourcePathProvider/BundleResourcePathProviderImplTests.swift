import MixboxTestsFoundation
import MixboxUiTestsFoundation

final class BundleResourcePathProviderImplTests: XCTestCase {
    func test_path_returnsPath_ifResourceExists_0() {
        check_path_returnsPath_ifResourceExists(
            resourceName: "BundleResourcePathProviderImplTests_with_extension.json"
        )
    }
    
    func test_path_returnsPath_ifResourceExists_1() {
        check_path_returnsPath_ifResourceExists(
            resourceName: "BundleResourcePathProviderImplTests_without_extension_json"
        )
    }
    
    func test_path_returnsPath_ifResourceExists_2() {
        check_path_returnsPath_ifResourceExists(
            resourceName: "BundleResourcePathProviderImplTests.with.lots.of.dots.json"
        )
    }
    
    private func check_path_returnsPath_ifResourceExists(resourceName: String) {
        XCTAssertNoThrow(
            try {
                let bundle = Bundle(for: BundleResourcePathProviderImplTests.self)
                
                let path = try BundleResourcePathProviderImpl(bundle: bundle)
                    .path(resource: resourceName)
                
                let matcher = RegularExpressionMatcher<String>(
                    regularExpression: ".*?" + NSRegularExpression.escapedPattern(for: resourceName) + "$"
                )
                
                switch matcher.match(value: path) {
                case .mismatch(let mismatchResult):
                    XCTFail("path doesn't match: \(mismatchResult.mismatchDescription)")
                case .match:
                    break
                }
            }()
        )
    }
    
    func test_path_throwsError_ifResourceDoesntExist() {
        let nonExistingResource = "5F4F01AD-EF1E-4C6F-9A91-14AB3D140530"
        
        do {
            _ = try BundleResourcePathProviderImpl(bundle: Bundle.main)
                .path(resource: nonExistingResource)
            
            XCTFail("Code was expected to throw exception, but it didn't")
        } catch {
            let message = "\(error)"
            
            let matcher = RegularExpressionMatcher<String>(
                regularExpression:
                    """
                    Bundle ".*?" doesn't contain resource named "\(nonExistingResource)"
                    """
            )
            
            switch matcher.match(value: message) {
            case .mismatch(let mismatchResult):
                XCTFail("exception description doesn't match: \(mismatchResult.mismatchDescription)")
            case .match:
                break
            }
        }
    }
}
