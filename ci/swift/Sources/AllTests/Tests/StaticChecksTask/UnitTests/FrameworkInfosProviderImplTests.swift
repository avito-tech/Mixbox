import Foundation
import CiFoundation
import XCTest
import StaticChecksTask
import Git

final class FrameworkInfosProviderImplTests: XCTestCase {
    let provider = FrameworkInfosProviderImpl()
    
    // Sorting frameworks is good for readability
    func test___frameworkInfos___provides_sorted_frameworks() {
        let frameworkNames = provider.frameworkInfos().map { $0.name }
        
        XCTAssertEqual(
            frameworkNames,
            frameworkNames.sorted()
        )
    }
    
    func test___frameworkInfos___provides_existing_and_only_existing_frameworks() {
        let enumerator = MixboxFrameworksEnumeratorImpl(
            filesEnumerator: FilesEnumeratorImpl(),
            frameworksDirectoryProvider: FrameworksDirectoryProviderImpl(
                repoRootProvider: RepoRootProviderImpl()
            )
        )
        
        let providedFrameworkNames = provider.frameworkInfos().map { $0.name }
        var fileSystemFrameworkNames = [String]()
        
        do {
            try enumerator.enumerateFrameworks { _, frameworkName in
                fileSystemFrameworkNames.append(frameworkName)
            }
        } catch {
            XCTFail("\(error)")
        }
        
        XCTAssertEqual(
            providedFrameworkNames.sorted(),
            fileSystemFrameworkNames.sorted()
        )
    }
}
