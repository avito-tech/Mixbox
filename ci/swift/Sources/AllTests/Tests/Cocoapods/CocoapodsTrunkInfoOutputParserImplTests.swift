import Cocoapods
import XCTest

final class CocoapodsTrunkInfoOutputParserImplTests: XCTestCase {
    private let parser: CocoapodsTrunkInfoOutputParser = CocoapodsTrunkInfoOutputParserImpl()
    
    func test() throws {
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
            
            XCTAssertEqual(result.podName, "MixboxFoundation")
            XCTAssertEqual(result.versions.count, 8)
            XCTAssertEqual(result.owners.count, 6)
            
            let version = result.versions[7]
            
            XCTAssertEqual(version.versionString, "0.2.81")
            XCTAssertEqual(version.releaseDate.timeIntervalSince1970, 1616499242)
            
            let owner = result.owners[0]
            
            XCTAssertEqual(owner.name, "Artyom Razinov")
            XCTAssertEqual(owner.email, "artyom.razinov@gmail.com")
            
        }
    }
}
