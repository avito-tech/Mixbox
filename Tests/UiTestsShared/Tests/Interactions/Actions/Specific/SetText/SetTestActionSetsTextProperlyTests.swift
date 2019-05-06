import MixboxUiTestsFoundation

final class SetTestActionSetsTextProperlyTests: BaseActionTestCase {
    // MARK: - Test Data
    
    func test_setText_withPasteInputMethod_setsTextProperly_0() {
        checkTextActionSetsTextProperly(
            inputMethod: .paste,
            testDataId: 0
        )
    }
    
    func test_setText_withPasteInputMethod_setsTextProperly_1() {
        checkTextActionSetsTextProperly(
            inputMethod: .paste,
            testDataId: 1
        )
    }
    
    func test_setText_withPasteInputMethod_setsTextProperly_2() {
        checkTextActionSetsTextProperly(
            inputMethod: .paste,
            testDataId: 2
        )
    }
    
    func test_setText_withPasteInputMethod_setsTextProperly_3() {
        checkTextActionSetsTextProperly(
            inputMethod: .paste,
            testDataId: 3
        )
    }
    
    func test_setText_withPasteInputMethod_setsTextProperly_4() {
        checkTextActionSetsTextProperly(
            inputMethod: .paste,
            testDataId: 4
        )
    }
    
    func test_setText_withPasteInputMethod_setsTextProperly_5() {
        checkTextActionSetsTextProperly(
            inputMethod: .paste,
            testDataId: 5
        )
    }
    
    func test_setText_withTypeInputMethod_setsTextProperly_0() {
        checkTextActionSetsTextProperly(
            inputMethod: .type,
            testDataId: 0
        )
    }
    
    func test_setText_withTypeInputMethod_setsTextProperly_1() {
        checkTextActionSetsTextProperly(
            inputMethod: .type,
            testDataId: 1
        )
    }
    
    func test_setText_withTypeInputMethod_setsTextProperly_2() {
        checkTextActionSetsTextProperly(
            inputMethod: .type,
            testDataId: 2
        )
    }
    
    func test_setText_withTypeInputMethod_setsTextProperly_3() {
        checkTextActionSetsTextProperly(
            inputMethod: .type,
            testDataId: 3
        )
    }
    
    func test_setText_withTypeInputMethod_setsTextProperly_4() {
        checkTextActionSetsTextProperly(
            inputMethod: .type,
            testDataId: 4
        )
    }
    
    // TODO: Fix typing for some specific languages
    func disabled_test_setText_withTypeInputMethod_setsTextProperly_5() {
        checkTextActionSetsTextProperly(
            inputMethod: .type,
            testDataId: 5
        )
    }
    
    // TODO: Fix, pasting is flaky
    /*
    func test_setText_withPasteUsingPopupMenusInputMethod_setsTextProperly_0() {
        checkTextActionSetsTextProperly(
            inputMethod: .pasteUsingPopupMenus,
            testDataId: 0
        )
    }
    
    func test_setText_withPasteUsingPopupMenusInputMethod_setsTextProperly_1() {
        checkTextActionSetsTextProperly(
            inputMethod: .pasteUsingPopupMenus,
            testDataId: 1
        )
    }
    
    func test_setText_withPasteUsingPopupMenusInputMethod_setsTextProperly_2() {
        checkTextActionSetsTextProperly(
            inputMethod: .pasteUsingPopupMenus,
            testDataId: 2
        )
    }
    
    func test_setText_withPasteUsingPopupMenusInputMethod_setsTextProperly_3() {
        checkTextActionSetsTextProperly(
            inputMethod: .pasteUsingPopupMenus,
            testDataId: 3
        )
    }
    
    func test_setText_withPasteUsingPopupMenusInputMethod_setsTextProperly_4() {
        checkTextActionSetsTextProperly(
            inputMethod: .pasteUsingPopupMenus,
            testDataId: 4
        )
    }
    
    func test_setText_withPasteUsingPopupMenusInputMethod_setsTextProperly_5() {
        checkTextActionSetsTextProperly(
            inputMethod: .pasteUsingPopupMenus,
            testDataId: 5
        )
    }
    */
    
    // MARK: - Test Logic
    
    
    private func checkTextActionSetsTextProperly(
        inputMethod: SetTextActionFactory.InputMethod,
        testDataId: Int)
    {
        func actionSpecification(text: String) -> ActionSpecification<InputElement> {
            return ActionSpecifications.setText(text: text, inputMethod: inputMethod)
        }
        
        setViews(
            showInfo: true,
            actionSpecifications: [actionSpecification(text: "does not matter")]
        )
        
        let testDataSet = [
            ["", "Non-empty string"],
            [""],
            ["Non-empty string", ""],
            ["Non-empty string", "Non-empty string"],
            ["Non-empty string", "Another non-empty string"],
            [helloWorldStrings.values.joined(separator: " ")]
        ]
        
        var resetView = true
        let testData = testDataSet[testDataId]
        
        
        for text in testData {
            let specification = actionSpecification(text: text)
            
            let sourceText = screen.input(specification.elementId).text()
            let emptyStringsIsSetInEmptyInput = text == "" && sourceText == ""
            let shouldSkipCheckThatEventIsTriggeredBecauseEventMayBeNotTriggeredAndItIsOkay = emptyStringsIsSetInEmptyInput
            if shouldSkipCheckThatEventIsTriggeredBecauseEventMayBeNotTriggeredAndItIsOkay {
                // Skip check
                
                // TODO: Improve ActionSpecifiaction Result depends on UI state. It doesn't only depend on action.
            } else {
                checkActionCausesExpectedResultIfIsPerformedOnce(
                    actionSpecification: specification,
                    resetViewsForCurrentActionSpecification: resetView,
                    errorMessageSuffix: {
                        ", test data: \(testData)"
                    }
                )
            }
            
            // Kludge: usage of abstract ActionSpecification assuming it enters text in the input
            // TODO: add asserts to ActionSpecification? They might be helpful.
            screen.input(specification.elementId).assertHasText(text)
            
            resetView = false
        }
    }
    
    private let helloWorldStrings: [String: String] = [
        "Afrikaans": "Hello Wêreld!",
        "Albanian": "Përshendetje Botë!",
        "Amharic": "ሰላም ልዑል!",
        "Arabic": "مرحبا بالعالم!",
        "Armenian": "Բարեւ աշխարհ!",
        "Basque": "Kaixo Mundua!",
        "Belarussian": "Прывітанне Сусвет!",
        "Bengali": "ওহে বিশ্ব!",
        "Bulgarian": "Здравей свят!",
        "Catalan": "Hola món!",
        "Chichewa": "Moni Dziko Lapansi!",
        "Chinese": "你好世界！",
        "Croatian": "Pozdrav svijete!",
        "Czech": "Ahoj světe!",
        "Danish": "Hej Verden!",
        "Dutch": "Hallo Wereld!",
        "English": "Hello World!",
        "Estonian": "Tere maailm!",
        "Finnish": "Hei maailma!",
        "French": "Bonjour monde!",
        "Frisian": "Hallo wrâld!",
        "Georgian": "გამარჯობა მსოფლიო!",
        "German": "Hallo Welt!",
        "Greek": "Γειά σου Κόσμε!",
        "Hausa": "Sannu Duniya!",
        "Hebrew": "שלום עולם!",
        "Hindi": "नमस्ते दुनिया!",
        "Hungarian": "Helló Világ!",
        "Icelandic": "Halló heimur!",
        "Igbo": "Ndewo Ụwa!",
        "Indonesian": "Halo Dunia!",
        "Italian": "Ciao mondo!",
        "Japanese": "こんにちは世界！",
        "Kazakh": "Сәлем Әлем!",
        "Khmer": "សួស្តី​ពិភពលោក!",
        "Kyrgyz": "Салам дүйнө!",
        "Lao": "ສະ​ບາຍ​ດີ​ຊາວ​ໂລກ!",
        "Latvian": "Sveika pasaule!",
        "Lithuanian": "Labas pasauli!",
        "Luxemburgish": "Moien Welt!",
        "Macedonian": "Здраво свету!",
        "Malay": "Hai dunia!",
        "Malayalam": "ഹലോ വേൾഡ്!",
        "Mongolian": "Сайн уу дэлхий!",
        "Myanmar": "မင်္ဂလာပါကမ္ဘာလောက!",
        "Nepali": "नमस्कार संसार!",
        "Norwegian": "Hei Verden!",
        "Pashto": "سلام نړی!",
        "Persian": "سلام دنیا!",
        "Polish": "Witaj świecie!",
        "Portuguese": "Olá Mundo!",
        "Punjabi": "ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ ਦੁਨਿਆ!",
        "Romanian": "Salut Lume!",
        "Russian": "Привет мир!",
        "Scots Gaelic": "Hàlo a Shaoghail!",
        "Serbian": "Здраво Свете!",
        "Sesotho": "Lefatše Lumela!",
        "Sinhala": "හෙලෝ වර්ල්ඩ්!",
        "Slovenian": "Pozdravljen svet!",
        "Spanish": "¡Hola Mundo!",
        "Sundanese": "Halo Dunya!",
        "Swahili": "Salamu Dunia!",
        "Swedish": "Hej världen!",
        "Tajik": "Салом Ҷаҳон!",
        "Thai": "สวัสดีชาวโลก!",
        "Turkish": "Selam Dünya!",
        "Ukrainian": "Привіт Світ!",
        "Uzbek": "Salom Dunyo!",
        "Vietnamese": "Chào thế giới!",
        "Welsh": "Helo Byd!",
        "Xhosa": "Molo Lizwe!",
        "Yiddish": "העלא וועלט!",
        "Yoruba": "Mo ki O Ile Aiye!",
        "Zulu": "Sawubona Mhlaba!"
    ]
}
