import Bash
import Git
import XCTest

public final class GitTagsProviderImplTests: XCTestCase {
    func test() {
        assertDoesntThrow {
            let repoRootProvider = RepoRootProviderImpl()
            
            let gitTagsProvider = GitTagsProviderImpl(
                processExecutor: FoundationProcessExecutor()
            )
            
            let gitTags = try gitTagsProvider.gitTags(
                repoRoot: try repoRootProvider.repoRootPath()
            )
            
            let knownTag = try gitTags.first { tag in
                tag.name == "0.2.5"
            }.unwrapOrThrow()
            
            XCTAssertEqual(
                knownTag.sha,
                "82d3bf3992cfb889c1f9f9812a09d8c33e7687d7"
            )
        }
    }
}
