import XCTest
import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxUiKit

// swiftlint:disable file_length function_body_length
class SnapshotComparisonTests: TestCase {
    private final class NamedImage {
        let name: String
        let image: UIImage
        
        init(name: String, image: UIImage) {
            self.name = name
            self.image = image
        }
    }
    
    override var reuseState: Bool {
        false
    }
    
    override func precondition() {
        super.precondition()
        continueAfterFailure = true
    }
    
    func test___PerPixel() {
        check(
            comparator: PerPixelSnapshotsComparator(
                tolerance: 0,
                forceUsingNonDiscretePercentageOfMatching: false
            ),
            expectedComparatorAccuracy: 1
        )
    }
    
    func test___AHash() {
        let expectedComparatorAccuracy: Double
        
        switch iosVersionProvider.iosVersion().majorVersion {
        case 11:
            expectedComparatorAccuracy = 0.7935483870967742
        default:
            expectedComparatorAccuracy = 0.8043010752688172
        }
        
        check(
            comparator: imageHashCalculatorSnapshotsComparator(
                imageHashCalculator: AHashImageHashCalculator()
            ),
            expectedComparatorAccuracy: expectedComparatorAccuracy,
            limitImages: 30
        )
    }
    
    func test___DHash() {
        let expectedComparatorAccuracy: Double
        
        switch iosVersionProvider.iosVersion().majorVersion {
        case 11:
            expectedComparatorAccuracy = 0.8688172043010752
        default:
            expectedComparatorAccuracy = 0.8817204301075269
        }
        
        check(
            comparator: imageHashCalculatorSnapshotsComparator(
                imageHashCalculator: DHashImageHashCalculator()
            ),
            expectedComparatorAccuracy: expectedComparatorAccuracy,
            limitImages: 30
        )
    }
    
    func test___PHash() {
        let expectedComparatorAccuracy: Double
        
        switch iosVersionProvider.iosVersion().majorVersion {
        case 11:
            expectedComparatorAccuracy = 0.9698924731182795
        default:
            expectedComparatorAccuracy = 0.9849462365591398
        }
        
        check(
            comparator: imageHashCalculatorSnapshotsComparator(
                imageHashCalculator: PHashImageHashCalculator()
            ),
            expectedComparatorAccuracy: expectedComparatorAccuracy,
            limitImages: 30
        )
    }
    
    private func imageHashCalculatorSnapshotsComparator(
        imageHashCalculator: ImageHashCalculator)
        -> ImageHashCalculatorSnapshotsComparator
    {
        return ImageHashCalculatorSnapshotsComparator(
            imageHashCalculator: imageHashCalculator,
            hashDistanceTolerance: 0,
            shouldIgnoreTransparency: true
        )
    }
    
    func check(
        comparator: SnapshotsComparator,
        expectedComparatorAccuracy: Double,
        limitImages: Int? = nil,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        let allImages = self.allImages(limit: limitImages)
        var failures = [String]()
        var checksCount = 0
        
        for (i, lhs) in allImages.enumerated() {
            for (j, rhs) in allImages.enumerated() {
                if j < i {
                    // skip; check only half of matrix, including diagonal line
                    // this will be enough
                    continue
                }
                
                let isSameImage = lhs.name == rhs.name
                
                let result = comparator.compare(
                    actualImage: lhs.image,
                    expectedImage: rhs.image
                )
                
                checksCount += 1
                
                switch result {
                case .similar:
                    if !isSameImage {
                        failures.append(
                            """
                            Expected images to be different, but comparator tells they are same.
                            `lhs`: \(lhs.name)
                            `rhs`: \(rhs.name)
                            """
                        )
                    }
                case .different(let description):
                    if isSameImage {
                        failures.append(
                            """
                            Expected images to be same, but comparator tells they are different.
                            `lhs`: \(lhs.name)
                            `rhs`: \(rhs.name)
                            `message`: \(description.message)
                            `percentageOfMatching`: \(description.percentageOfMatching)
                            """
                        )
                    }
                }
            }
        }
        
        let actualComparatorAccuracy = Double(checksCount - failures.count) / Double(checksCount)
        let difference = (expectedComparatorAccuracy - actualComparatorAccuracy).magnitude
        
        let isOk = expectedComparatorAccuracy == 1
            ? difference == 0
            : difference <= 0.0001
        
        if !isOk {
            XCTFail(
                """
                Comparator has \(actualComparatorAccuracy) accuracy at differentiating icons.
                Expected accuracy is \(expectedComparatorAccuracy)
                
                First 10 failures:
                
                \(failures.prefix(10).joined(separator: "\n\n"))
                """,
                file: file,
                line: line
            )
        }
    }
    
    private func allImages(limit: Int?) -> [NamedImage] {
        let allImages: [NamedImage] = allFillImageNames.map {
            image(name: "eva_icons/fill/\($0)")
        } + allOutlineImageNames.filter { !outlineImagesThatAreSimilarToFillImages.contains($0) }.map {
            image(name: "eva_icons/outline/\($0)")
        }
        
        if let limit = limit {
            return Array(allImages.prefix(limit))
        } else {
            return allImages
        }
    }
    
    private func image(name: String) -> NamedImage {
        return NamedImage(
            name: name,
            image: image(name: name)
        )
    }
}

private let outlineImagesThatAreSimilarToFillImages: Set<String> = [
    "activity-outline",
    "arrow-back-outline",
    "arrow-downward-outline",
    "arrow-forward-outline",
    "arrow-ios-back-outline",
    "arrow-ios-downward-outline",
    "arrow-ios-forward-outline",
    "arrow-ios-upward-outline",
    "arrow-upward-outline",
    "arrowhead-down-outline",
    "arrowhead-left-outline",
    "arrowhead-right-outline",
    "arrowhead-up-outline",
    "at-outline",
    "attach-2-outline",
    "attach-outline",
    "bar-chart-2-outline",
    "bar-chart-outline",
    "bluetooth-outline",
    "cast-outline",
    "checkmark-circle-outline",
    "checkmark-outline",
    "checkmark-square-outline",
    "chevron-down-outline",
    "chevron-left-outline",
    "chevron-right-outline",
    "chevron-up-outline",
    "close-outline",
    "code-download-outline",
    "code-outline",
    "collapse-outline",
    "corner-down-left-outline",
    "corner-down-right-outline",
    "corner-left-down-outline",
    "corner-left-up-outline",
    "corner-right-down-outline",
    "corner-right-up-outline",
    "corner-up-left-outline",
    "corner-up-right-outline",
    "crop-outline",
    "diagonal-arrow-left-down-outline",
    "diagonal-arrow-left-up-outline",
    "diagonal-arrow-right-down-outline",
    "diagonal-arrow-right-up-outline",
    "done-all-outline",
    "download-outline",
    "expand-outline",
    "external-link-outline",
    "eye-off-2-outline",
    "flip-2-outline",
    "flip-outline",
    "globe-outline",
    "hash-outline",
    "link-2-outline",
    "link-outline",
    "list-outline",
    "log-in-outline",
    "log-out-outline",
    "menu-2-outline",
    "menu-arrow-outline",
    "menu-outline",
    "minus-outline",
    "more-horizontal-outline",
    "more-vertical-outline",
    "move-outline",
    "paper-plane-outline",
    "percent-outline",
    "plus-outline",
    "power-outline",
    "question-mark-outline",
    "radio-button-off-outline",
    "refresh-outline",
    "repeat-outline",
    "scissors-outline",
    "search-outline",
    "shake-outline",
    "shuffle-2-outline",
    "shuffle-outline",
    "slash-outline",
    "smiling-face-outline",
    "square-outline",
    "swap-outline",
    "sync-outline",
    "text-outline",
    "trending-down-outline",
    "trending-up-outline",
    "upload-outline",
    "wifi-off-outline",
    "wifi-outline"
]

private let allFillImageNames: [String] = [
    "activity",
    "alert-circle",
    "alert-triangle",
    "archive",
    "arrow-back",
    "arrow-circle-down",
    "arrow-circle-left",
    "arrow-circle-right",
    "arrow-circle-up",
    "arrow-down",
    "arrow-downward",
    "arrow-forward",
    "arrow-ios-back",
    "arrow-ios-downward",
    "arrow-ios-forward",
    "arrow-ios-upward",
    "arrow-left",
    "arrow-right",
    "arrow-up",
    "arrow-upward",
    "arrowhead-down",
    "arrowhead-left",
    "arrowhead-right",
    "arrowhead-up",
    "at",
    "attach-2",
    "attach",
    "award",
    "backspace",
    "bar-chart-2",
    "bar-chart",
    "battery",
    "behance",
    "bell-off",
    "bell",
    "bluetooth",
    "book-open",
    "book",
    "bookmark",
    "briefcase",
    "browser",
    "brush",
    "bulb",
    "calendar",
    "camera",
    "car",
    "cast",
    "charging",
    "checkmark-circle-2",
    "checkmark-circle",
    "checkmark-square-2",
    "checkmark-square",
    "checkmark",
    "chevron-down",
    "chevron-left",
    "chevron-right",
    "chevron-up",
    "clipboard",
    "clock",
    "close-circle",
    "close-square",
    "close",
    "cloud-download",
    "cloud-upload",
    "code-download",
    "code",
    "collapse",
    "color-palette",
    "color-picker",
    "compass",
    "copy",
    "corner-down-left",
    "corner-down-right",
    "corner-left-down",
    "corner-left-up",
    "corner-right-down",
    "corner-right-up",
    "corner-up-left",
    "corner-up-right",
    "credit-card",
    "crop",
    "cube",
    "diagonal-arrow-left-down",
    "diagonal-arrow-left-up",
    "diagonal-arrow-right-down",
    "diagonal-arrow-right-up",
    "done-all",
    "download",
    "droplet-off",
    "droplet",
    "edit-2",
    "edit",
    "email",
    "expand",
    "external-link",
    "eye-off-2",
    "eye-off",
    "eye",
    "facebook",
    "file-add",
    "file-remove",
    "file-text",
    "file",
    "film",
    "flag",
    "flash-off",
    "flash",
    "flip-2",
    "flip",
    "folder-add",
    "folder-remove",
    "folder",
    "funnel",
    "gift",
    "github",
    "globe-2",
    "globe-3",
    "globe",
    "google",
    "grid",
    "hard-drive",
    "hash",
    "headphones",
    "heart",
    "home",
    "image-2",
    "image",
    "inbox",
    "info",
    "keypad",
    "layers",
    "layout",
    "link-2",
    "link",
    "linkedin",
    "list",
    "lock",
    "log-in",
    "log-out",
    "map",
    "maximize",
    "menu-2",
    "menu-arrow",
    "menu",
    "message-circle",
    "message-square",
    "mic-off",
    "mic",
    "minimize",
    "minus-circle",
    "minus-square",
    "minus",
    "monitor",
    "moon",
    "more-horizontal",
    "more-vertical",
    "move",
    "music",
    "navigation-2",
    "navigation",
    "npm",
    "options-2",
    "options",
    "pantone",
    "paper-plane",
    "pause-circle",
    "people",
    "percent",
    "person-add",
    "person-delete",
    "person-done",
    "person-remove",
    "person",
    "phone-call",
    "phone-missed",
    "phone-off",
    "phone",
    "pie-chart-2",
    "pie-chart",
    "pin",
    "play-circle",
    "plus-circle",
    "plus-square",
    "plus",
    "power",
    "pricetags",
    "printer",
    "question-mark-circle",
    "question-mark",
    "radio-button-off",
    "radio-button-on",
    "radio",
    "recording",
    "refresh",
    "repeat",
    "rewind-left",
    "rewind-right",
    "save",
    "scissors",
    "search",
    "settings-2",
    "settings",
    "shake",
    "share",
    "shield-off",
    "shield",
    "shopping-bag",
    "shopping-cart",
    "shuffle-2",
    "shuffle",
    "skip-back",
    "skip-forward",
    "slash",
    "smartphone",
    "smiling-face",
    "speaker",
    "square",
    "star",
    "stop-circle",
    "sun",
    "swap",
    "sync",
    "text",
    "thermometer-minus",
    "thermometer-plus",
    "thermometer",
    "toggle-left",
    "toggle-right",
    "trash-2",
    "trash",
    "trending-down",
    "trending-up",
    "tv",
    "twitter",
    "umbrella",
    "undo",
    "unlock",
    "upload",
    "video-off",
    "video",
    "volume-down",
    "volume-mute",
    "volume-off",
    "volume-up",
    "wifi-off",
    "wifi"
]

private let allOutlineImageNames: [String] = [
    "activity-outline",
    "alert-circle-outline",
    "alert-triangle-outline",
    "archive-outline",
    "arrow-back-outline",
    "arrow-circle-down-outline",
    "arrow-circle-left-outline",
    "arrow-circle-right-outline",
    "arrow-circle-up-outline",
    "arrow-down-outline",
    "arrow-downward-outline",
    "arrow-forward-outline",
    "arrow-ios-back-outline",
    "arrow-ios-downward-outline",
    "arrow-ios-forward-outline",
    "arrow-ios-upward-outline",
    "arrow-left-outline",
    "arrow-right-outline",
    "arrow-up-outline",
    "arrow-upward-outline",
    "arrowhead-down-outline",
    "arrowhead-left-outline",
    "arrowhead-right-outline",
    "arrowhead-up-outline",
    "at-outline",
    "attach-2-outline",
    "attach-outline",
    "award-outline",
    "backspace-outline",
    "bar-chart-2-outline",
    "bar-chart-outline",
    "battery-outline",
    "behance-outline",
    "bell-off-outline",
    "bell-outline",
    "bluetooth-outline",
    "book-open-outline",
    "book-outline",
    "bookmark-outline",
    "briefcase-outline",
    "browser-outline",
    "brush-outline",
    "bulb-outline",
    "calendar-outline",
    "camera-outline",
    "car-outline",
    "cast-outline",
    "charging-outline",
    "checkmark-circle-2-outline",
    "checkmark-circle-outline",
    "checkmark-outline",
    "checkmark-square-2-outline",
    "checkmark-square-outline",
    "chevron-down-outline",
    "chevron-left-outline",
    "chevron-right-outline",
    "chevron-up-outline",
    "clipboard-outline",
    "clock-outline",
    "close-circle-outline",
    "close-outline",
    "close-square-outline",
    "cloud-download-outline",
    "cloud-upload-outline",
    "code-download-outline",
    "code-outline",
    "collapse-outline",
    "color-palette-outline",
    "color-picker-outline",
    "compass-outline",
    "copy-outline",
    "corner-down-left-outline",
    "corner-down-right-outline",
    "corner-left-down-outline",
    "corner-left-up-outline",
    "corner-right-down-outline",
    "corner-right-up-outline",
    "corner-up-left-outline",
    "corner-up-right-outline",
    "credit-card-outline",
    "crop-outline",
    "cube-outline",
    "diagonal-arrow-left-down-outline",
    "diagonal-arrow-left-up-outline",
    "diagonal-arrow-right-down-outline",
    "diagonal-arrow-right-up-outline",
    "done-all-outline",
    "download-outline",
    "droplet-off-outline",
    "droplet-outline",
    "edit-2-outline",
    "edit-outline",
    "email-outline",
    "expand-outline",
    "external-link-outline",
    "eye-off-2-outline",
    "eye-off-outline",
    "eye-outline",
    "facebook-outline",
    "file-add-outline",
    "file-outline",
    "file-remove-outline",
    "file-text-outline",
    "film-outline",
    "flag-outline",
    "flash-off-outline",
    "flash-outline",
    "flip-2-outline",
    "flip-outline",
    "folder-add-outline",
    "folder-outline",
    "folder-remove-outline",
    "funnel-outline",
    "gift-outline",
    "github-outline",
    "globe-2-outline",
    "globe-outline",
    "google-outline",
    "grid-outline",
    "hard-drive-outline",
    "hash-outline",
    "headphones-outline",
    "heart-outline",
    "home-outline",
    "image-outline",
    "inbox-outline",
    "info-outline",
    "keypad-outline",
    "layers-outline",
    "layout-outline",
    "link-2-outline",
    "link-outline",
    "linkedin-outline",
    "list-outline",
    "loader-outline",
    "lock-outline",
    "log-in-outline",
    "log-out-outline",
    "map-outline",
    "maximize-outline",
    "menu-2-outline",
    "menu-arrow-outline",
    "menu-outline",
    "message-circle-outline",
    "message-square-outline",
    "mic-off-outline",
    "mic-outline",
    "minimize-outline",
    "minus-circle-outline",
    "minus-outline",
    "minus-square-outline",
    "monitor-outline",
    "moon-outline",
    "more-horizontal-outline",
    "more-vertical-outline",
    "move-outline",
    "music-outline",
    "navigation-2-outline",
    "navigation-outline",
    "npm-outline",
    "options-2-outline",
    "options-outline",
    "pantone-outline",
    "paper-plane-outline",
    "pause-circle-outline",
    "people-outline",
    "percent-outline",
    "person-add-outline",
    "person-delete-outline",
    "person-done-outline",
    "person-outline",
    "person-remove-outline",
    "phone-call-outline",
    "phone-missed-outline",
    "phone-off-outline",
    "phone-outline",
    "pie-chart-outline",
    "pin-outline",
    "play-circle-outline",
    "plus-circle-outline",
    "plus-outline",
    "plus-square-outline",
    "power-outline",
    "pricetags-outline",
    "printer-outline",
    "question-mark-circle-outline",
    "question-mark-outline",
    "radio-button-off-outline",
    "radio-button-on-outline",
    "radio-outline",
    "recording-outline",
    "refresh-outline",
    "repeat-outline",
    "rewind-left-outline",
    "rewind-right-outline",
    "save-outline",
    "scissors-outline",
    "search-outline",
    "settings-2-outline",
    "settings-outline",
    "shake-outline",
    "share-outline",
    "shield-off-outline",
    "shield-outline",
    "shopping-bag-outline",
    "shopping-cart-outline",
    "shuffle-2-outline",
    "shuffle-outline",
    "skip-back-outline",
    "skip-forward-outline",
    "slash-outline",
    "smartphone-outline",
    "smiling-face-outline",
    "speaker-outline",
    "square-outline",
    "star-outline",
    "stop-circle-outline",
    "sun-outline",
    "swap-outline",
    "sync-outline",
    "text-outline",
    "thermometer-minus-outline",
    "thermometer-outline",
    "thermometer-plus-outline",
    "toggle-left-outline",
    "toggle-right-outline",
    "trash-2-outline",
    "trash-outline",
    "trending-down-outline",
    "trending-up-outline",
    "tv-outline",
    "twitter-outline",
    "umbrella-outline",
    "undo-outline",
    "unlock-outline",
    "upload-outline",
    "video-off-outline",
    "video-outline",
    "volume-down-outline",
    "volume-mute-outline",
    "volume-off-outline",
    "volume-up-outline",
    "wifi-off-outline",
    "wifi-outline"
]
