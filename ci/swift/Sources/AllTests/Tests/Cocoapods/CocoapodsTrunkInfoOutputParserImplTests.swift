import Cocoapods
import XCTest

final class CocoapodsTrunkInfoOutputParserImplTests: XCTestCase {
    private let parser: CocoapodsTrunkInfoOutputParser = CocoapodsTrunkInfoOutputParserImpl()
    
    func test___parse___returns_found___if_output_contains_info() throws {
        assertDoesntThrow {
            let result = try parser.parse(
                output:
                """
                MixboxFoundation
                    - Versions:
                      - 0.0.1 (2018-08-07 13:14:13 UTC)
                      - 0.0.2 (2019-02-26 08:06:45 UTC)
                      - 0.2.0 (2019-05-28 19:03:12 UTC)
                      - 0.2.1 (2019-05-29 01:13:56 UTC)
                      - 0.2.2 (2019-05-29 01:22:27 UTC)
                      - 0.2.3 (2019-05-29 16:05:54 UTC)
                      - 0.2.80 (2021-03-19 15:28:56 UTC)
                      - 0.2.81 (2021-03-23 11:34:02 UTC)
                    - Owners:
                      - Artyom Razinov <artyom.razinov@gmail.com>
                      - Artyom Razinov <arazinov@avito.ru>
                      - Vladislav Alekseev <vvalekseev@avito.ru>
                      - Timofey Solonin <tssolonin@avito.ru>
                      - Vladimir Ignatov <vyuignatov@avito.ru>
                      - Alexey Shpirko <ashpirko@avito.ru>
                """
            )
            
            guard case .found(let info) = result else {
                XCTFail("Expected to find info")
                return
            }
            
            XCTAssertEqual(info.podName, "MixboxFoundation")
            XCTAssertEqual(info.versions.count, 8)
            XCTAssertEqual(info.owners.count, 6)
            
            let version = info.versions[7]
            
            XCTAssertEqual(version.versionString, "0.2.81")
            XCTAssertEqual(version.releaseDate.timeIntervalSince1970, 1616499242)
            
            let owner = info.owners[0]
            
            XCTAssertEqual(owner.name, "Artyom Razinov")
            XCTAssertEqual(owner.email, "artyom.razinov@gmail.com")
            
        }
    }
    
    func test___parse___returns_notFound___if_output_contains_special_string() throws {
        assertDoesntThrow {
            let result = try parser.parse(
                output:
                """
                [!] No pod found with the specified name.
                """
            )
            
            guard case .notFound = result else {
                XCTFail("Expected to find info")
                return
            }
        }
    }
    func test___parse___returns_notFound___if_output_contains_invalid_string() throws {
        assertThrows {
            _ = try parser.parse(
                output:
                """
                Invalid string
                """
            )
        }
    }
}
