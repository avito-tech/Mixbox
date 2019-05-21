import Foundation
import CiFoundation
import Bash

// Translated from `emcee.sh` bash script with little changes.
// Note that it still uses a lot of singletons
public protocol Emcee {
    func testUsingEmcee(
        appName: String,
        testsTarget: String,
        additionalApp: String)
        throws
}
