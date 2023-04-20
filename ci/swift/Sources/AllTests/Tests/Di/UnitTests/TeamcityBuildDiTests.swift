import XCTest
import TeamcityDi
import DI
import BuildDsl
import CiFoundation
import SingletonHell

import TeamcityBlackBoxTestsBuild
import TeamcityCheckReleaseToCocoapodsBuild
import TeamcityGrayBoxTestsBuild
import TeamcityIpcDemoBuild
import TeamcityLogicTestsBuild
import TeamcityManagePodOwnersBuild
import TeamcityReleaseToCocoapodsBuild
import TeamcityStaticChecksBuild
import TeamcityUiTestsDemoBuild

final class TeamcityBuildDiTests: XCTestCase {
    func test() {
        for build in allBuilds() {
            let di = build.di()
            
            di.register(type: EnvironmentProvider.self) { _ in
                Self.environmentProvider()
            }
            
            XCTAssertNoThrow(try build.task(di: di))
        }
    }
    
    private func allBuilds() -> [TeamcityBuild] {
        [
            TeamcityBlackBoxTestsBuild(),
            TeamcityCheckReleaseToCocoapodsBuild(),
            TeamcityGrayBoxTestsBuild(),
            TeamcityIpcDemoBuild(),
            TeamcityLogicTestsBuild(),
            TeamcityManagePodOwnersBuild(),
            TeamcityReleaseToCocoapodsBuild(),
            TeamcityStaticChecksBuild(),
            TeamcityUiTestsDemoBuild()
        ]
    }
    
    private static func environmentProvider() -> EnvironmentProvider {
        EnvironmentProviderMock(
            environment: ProcessInfoEnvironmentProvider(
                processInfo: ProcessInfo.processInfo
            ).environment.merging(
                Dictionary(
                    uniqueKeysWithValues: Env.allCases.map {
                        (key: $0.rawValue, value: "irrelevant")
                    }
                ),
                uniquingKeysWith: { lhs, _ in
                    lhs
                }
            )
        )
    }
}
