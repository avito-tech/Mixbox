import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest
import MixboxUiKit

// TODO: Rewrite, split into smaller atomic tests. Note that this test found bugs before, so it is importand.
final class ThirdPartyAppsTests: TestCase {
    func test() {
        installApp()
        goToFirstPageOnHomeScreen()
        
        // Assert that we are on the page that doesn't contain app icon.
        // This is an important check, it checks if visibility check works (there was a bug! UPD: twice):
        pageObjects.springboard.mainAppIcon.withoutTimeout.withoutScrolling.assertIsNotDisplayed()
        
        pageObjects.springboard.scrollToMainAppIcon()
            
        waiter.wait(timeout: 1)
        
        pageObjects.springboard.mainAppIcon.assertIsDisplayed()
        
        pageObjects.springboard.deleteApp()
        
        pageObjects.springboard.mainAppIcon.assertIsNotDisplayed()
        
        XCUIDevice.shared.press(.home)
    }
    
    private func installApp() {
        // Install app, terminate it, so there will be
        // an app installed and home screen will be displayed.
        XCUIApplication().launch()
        XCUIApplication().terminate()
    }
    
    private func goToFirstPageOnHomeScreen() {
        pageObjects.springboard.anyWindow.swipeRight()
        pageObjects.springboard.anyWindow.swipeRight()
        pageObjects.springboard.anyWindow.swipeRight()
        
        while pageObjects.springboard.okButton.tap(failTest: false) {
            // skip alert, example alert (on iOS 14):
            // Refreshed Widgets
            // Press and hold a widget to reorganize it. In jiggle mode, tap the plus at the top to add more widgets.
        }
    }
}

private class Springboard: BasePageObjectWithDefaultInitializer {
    private let applicationName = ApplicationNameProvider.applicationName
    
    var mainAppIcon: ViewElement {
        return element("Main app icon") { element in
            element.type == .icon && element.accessibilityLabel == applicationName
        }
    }
    
    var anyWindow: ViewElement {
        return any.element("Any window") { element in
            element.type == .window
        }
    }
    
    var okButton: ViewElement {
        return any.element("Any window") { element in
            element.text == "OK"
        }
    }
    
    var intermediateDeleteAppAlertButton: ButtonElement {
        deleteAppAlertButton { label, localizedDeleteText in
            // The alert contains "Delete" substring. This alert is different
            // than one in `finalDeleteAppAlertButton`.
            // I didn't make localization, but I hope it will work fine.
            label.contains(localizedDeleteText)
        }
    }
    
    var finalDeleteAppAlertButton: ButtonElement {
        deleteAppAlertButton { label, localizedDeleteText in
            label == localizedDeleteText
        }
    }
    
    func deleteAppAlertButton(
        matchLabel: (PropertyMatcherBuilder<ElementSnapshot, String>, String) -> Matcher<ElementSnapshot>)
        -> ButtonElement
    {
        return element("Delete button on alert") { element in
            let title = deleteButtonTitles[NSLocale.current.languageCode ?? "English"] ?? "Delete"
            
            return element.type == .button
                && matchLabel(element.accessibilityLabel, title)
                && element.isSubviewOf { $0 .type == .alert }
        }
    }
    
    func deleteApp() {
        // At this moment UI will be probably stable:
        
        switch iosVersion.majorVersion {
        case ...MixboxIosVersions.Outdated.iOS12.majorVersion:
            mainAppIcon.press(duration: 1.5)
            mainAppIconDeleteButtonForIos12OrLower.tap()
        case MixboxIosVersions.Outdated.iOS13.majorVersion:
            // iOS 13 introduced and intermediate menu, but longer press works fine (> 3 secs)
            mainAppIcon.press(duration: 5)
            
            mainAppIcon.tap(
                normalizedCoordinate: CGPoint(x: 0, y: 0),
                absoluteOffset: CGVector(dx: 5, dy: 5)
            )
        case MixboxIosVersions.Supported.iOS14.majorVersion...MixboxIosVersions.Supported.iOS15.majorVersion:
            mainAppIcon.press(duration: 5)
            
            // iOS 14 introduced also an alert (some "feature discovery" thing, I didn't remember the text)
            okButton.tap(failTest: false)
            
            mainAppIcon.tap(
                normalizedCoordinate: CGPoint(x: 0, y: 0),
                absoluteOffset: CGVector(dx: 5, dy: 5)
            )
            
            intermediateDeleteAppAlertButton.tap()
        case MixboxIosVersions.Supported.iOS16.majorVersion...:
            mainAppIcon.press(duration: 5)
            
            mainAppIcon.tap(
                normalizedCoordinate: CGPoint(x: 0, y: 0),
                absoluteOffset: CGVector(dx: 5, dy: 5)
            )
            
            intermediateDeleteAppAlertButton.tap()
        default:
            XCTFail("Unsupported iOS: \(iosVersion)") // Seemingly impossible case given other current cases.
        }
        
        // Note: there was a bug. Cancel button was tapped instead of delete button.
        // The reason is that XCUI cancels every alert if there is an interaction with other element.
        // Every action in Mixbox performed on XCUIApplication, by coordinates (that fixes some XCUI bugs
        // and makes tests more blackbox, but the reason was really fixing bugs).
        //
        // It was fixed by adding a workaround: tap alert XCUIElement by coordinate instead of tapping
        // XCUIApplication by coordinate.
        finalDeleteAppAlertButton.tap()
    }
    
    func scrollToMainAppIcon() {
        if iosVersion.majorVersion <= MixboxIosVersions.Outdated.iOS12.majorVersion {
            // This will trigger scroll:
            mainAppIcon.assertIsDisplayed()
        } else {
            // Since iOS 13 app icons lost their frames.
            // We can only scroll blindly:
            
            while !mainAppIcon.withoutScrolling.withoutTimeout.isDisplayed() {
                anyWindow.swipeLeft()
            }
        }
    }
    
    // There is no way to find delete button on iOS 13
    private var mainAppIconDeleteButtonForIos12OrLower: ButtonElement {
        return element("Delete button on main app icon") { element in
            element.id == "DeleteButton" && element.type == .button && element.isSubviewOf { element in
                (element.type == .icon /* iOS 10 */ || element.type == .other /* iOS 9 */)
                    && element.accessibilityLabel == applicationName
                    && element.id == applicationName
            }
        }
    }
}

// IFS=$'\n'; for file in `find "./Contents/Resources/RuntimeRoot/System/Library/AccessibilityBundles/SpringBoard.axbundle/" -name "*.strings"`; do echo -n "$file ::"; plutil -p "$file"|grep "delete.key"; done
private let deleteButtonTitles: [String: String] = [
    "he": "מחק",
    "en_AU": "Delete",
    "ar": "حذف",
    "el": "Διαγραφή",
    "uk": "Видалити",
    "English": "Delete",
    "es_419": "Eliminar",
    "zh_CN": "删除",
    "Dutch": "Verwijder",
    "da": "Slet",
    "sk": "Vymazať",
    "pt_PT": "Apagar",
    "German": "Löschen",
    "ms": "Padam",
    "sv": "Radera",
    "cs": "Smazat",
    "ko": "삭제",
    "yue_CN": "删除",
    "no": "Slett",
    "hu": "Törlés",
    "zh_HK": "刪除",
    "Spanish": "Eliminar",
    "tr": "Sil",
    "pl": "Usuń",
    "zh_TW": "刪除",
    "en_GB": "Delete",
    "French": "Supprimer",
    "vi": "Xóa",
    "ru": "Удалить",
    "fr_CA": "Supprimer",
    "fi": "Poista",
    "id": "Hapus",
    "th": "ลบ",
    "pt": "Apagar",
    "ro": "Ștergeți",
    "Japanese": "削除",
    "hr": "Obriši",
    "hi": "डिलीट करें",
    "Italian": "Elimina",
    "ca": "Eliminar"
]

private extension PageObjects {
    var springboard: Springboard {
        return apps.springboard.pageObject()
    }
}

/*
 UI Test Activity:
 Find: Elements matching predicate 'userTestingAttributes CONTAINS "cancel-button"'
 */
