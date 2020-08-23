import Cocoapods
import XCTest

final class CocoapodsSearchOutputParserImplTests: XCTestCase {
    private let parser: CocoapodsSearchOutputParser = CocoapodsSearchOutputParserImpl()
    
    func test() throws {
        assertDoesntThrow {
            let result = try parser.parse(
                output:
                """
                -> MixboxFoundation (0.2.3)
                   Shared simple general purpose utilities
                   pod 'MixboxFoundation', '~> 0.2.3'
                   - Homepage: https://github.com/avito-tech/Mixbox
                   - Source:
                   http://security.champion.imma/repository/ios-speed-cocoapods-proxy/pods/MixboxFoundation/0.2.3/https/api.github.com/repos/avito-tech/Mixbox/tarball/Mixbox-0.2.3.tar.gz
                   - Versions: 0.2.3, 0.2.2, 0.2.1, 0.2.0, 0.0.2, 0.0.1 [avito-repository-ios-speed-cocoapods-proxy repo] - 0.2.3, 0.2.2, 0.2.1, 0.2.0, 0.0.2, 0.0.1 [cocoapods repo] - 0.2.3,
                   0.2.2, 0.2.1, 0.2.0, 0.0.2, 0.0.1 [trunk repo]
                   - Author:   Hive of coders from Avito
                   - License:  MIT
                   - Platform: iOS 9.0 - macOS 10.13
                   - Stars:    1
                   - Forks:    0
                """
            )
            
            guard let pod = result.pods.first, result.pods.count == 1 else {
                XCTFail("Expected 1 element in pods, got \(result.pods.count)")
                return
            }
            
            XCTAssertEqual(pod.name, "MixboxFoundation")
            XCTAssertEqual(pod.latestVersion, "0.2.3")
            XCTAssertEqual(pod.description, "Shared simple general purpose utilities")
            XCTAssertEqual(pod.usage, "pod 'MixboxFoundation', '~> 0.2.3'")
            XCTAssertEqual(pod.homepage, "https://github.com/avito-tech/Mixbox")
            XCTAssertEqual(pod.source, "http://security.champion.imma/repository/ios-speed-cocoapods-proxy/pods/MixboxFoundation/0.2.3/https/api.github.com/repos/avito-tech/Mixbox/tarball/Mixbox-0.2.3.tar.gz")
            XCTAssertEqual(
                pod.versions,
                [
                    "avito-repository-ios-speed-cocoapods-proxy": ["0.2.3", "0.2.2", "0.2.1", "0.2.0", "0.0.2", "0.0.1"],
                    "cocoapods": ["0.2.3", "0.2.2", "0.2.1", "0.2.0", "0.0.2", "0.0.1"],
                    "trunk": ["0.2.3", "0.2.2", "0.2.1", "0.2.0", "0.0.2", "0.0.1"]
                ]
            )
            XCTAssertEqual(pod.author, "Hive of coders from Avito")
            XCTAssertEqual(pod.license, "MIT")
            XCTAssertEqual(
                pod.platforms,
                [
                    "iOS": "9.0",
                    "macOS": "10.13"
                ]
            )
            XCTAssertEqual(pod.stars, 1)
            XCTAssertEqual(pod.forks, 0)
        }
    }
}
