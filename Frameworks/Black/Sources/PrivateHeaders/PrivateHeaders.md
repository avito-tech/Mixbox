# Приватные хедеры XCTest

В `XCUIApplication` можно найти элементы с помощью пропертей, возвращающих `XCUIElementQuery`.

В `XCUIElementQuery` есть метод `element(matcher: NSPredicate)`. Если послать туда `NSPredicate(block:)`, то в блоке будут параметры типа `XCElementSnapshot`, а это приватный класс. Это довольно жестоко со стороны `Apple`, так как нормально поискать элементы они не дают.

Приватные хедеры экспозят интерфейс `XCElementSnapshot`. Альтернативы этому - юзать публичный интерфейс `XCUIElementQuery `, там есть разные функции по фильтрации вьюшек. Также есть строковые предикаты.

Самый простой способ сделать нормальные локаторы - это как раз `element(matcher: NSPredicate)` + `NSPredicate(block:)`.

Недостаток - приватные хедеры. Но это не проблема, так как в принципе весь наш фреймворк тестов - это абстракция над EarlGrey и XCUI. Тесты не зависят от EarlGrey и XCUI.

Также есть дополнительная абстракция `XcuiElementSnapshot` над `XCElementSnapshot`.

Приватные хедеры взяты из <https://github.com/facebook/WebDriverAgent> и поправлены, чтобы хоть как-то компилились.
