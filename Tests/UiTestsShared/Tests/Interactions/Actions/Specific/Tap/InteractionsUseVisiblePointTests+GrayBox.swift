extension InteractionsUseVisiblePointTests {
    // TODO: Fix for BlackBox. Move from extension, make internal things rpivate.
    // TODO: Fix some cases. This test will be helpful in debugging:
    //
    // func test() {
    //     resetUi(
    //         fractionOfPoint: 6,
    //         offsetInFractionsOfPoint: -6,
    //         layout: .vertical,
    //         overlapped: false
    //     )
    //     checkButton()
    // }
    func test___tap___taps_buttons_with_size_less_than_a_point() {
        // TODO: Fix for iPhone 7, iOS 11.4, iPhone 5s, iOS 10.3 (it fails on CI)
        switch iosVersionProvider.iosVersion().majorVersion {
        case 10, 11:
            return
        default:
            break
        }
        
        for overlapped in [false/*, true */] {
            for layout in ButtonLayout.allCases {
                // To test different scales and also just different coordinates
                for fractionOfPoint in [2, 3, 4, 5/* , 6, 7, 8 */] {
                    for offsetInFractionsOfPoint in -fractionOfPoint...fractionOfPoint {
                        resetUi(
                            fractionOfPoint: fractionOfPoint,
                            offsetInFractionsOfPoint: offsetInFractionsOfPoint,
                            layout: layout,
                            overlapped: overlapped
                        )
                        assertPasses(
                            message: { failures in
                                """
                                Test failed on this data set:
                                fractionOfPoint: \(fractionOfPoint)
                                offsetInFractionsOfPoint: \(offsetInFractionsOfPoint)
                                layout: \(layout)
                                overlapped: \(overlapped)
                                
                                Failures: \(failures)
                                """
                            },
                            body: {
                                checkButton()
                            }
                        )
                    }
                }
            }
        }
    }
}
