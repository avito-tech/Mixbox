// This class is a helper to make describing PageObjects easier by providing functions
// to make all page object elements (the main purpose of PageObject is to provide page object elements)
//
// EDITING:
//
// If you want to add another type of the element
// you should be able to understand the fundamentals
// of programming in Swift:
// - ⌘ + C
// - ⌘ + V
// Just replace the type of your page object element (ViewElement/ButtonElement/etc)
//
// If you can make it easier, let us know. Now it doesn't seem to be a big problem.
//
// TODOs:
//
// TODO: Rename to something that expresses the purpose of this class more accurately.

public protocol PageObjectElementRegistrar: class {
    func element<T: ElementWithDefaultInitializer>(
        _ name: String,
        matcherBuilder: (PredicateNodePageObjectElement) -> PredicateNode)
        -> T
    
    func with(searchMode: SearchMode) -> PageObjectElementRegistrar
    func with(interactionMode: InteractionMode) -> PageObjectElementRegistrar
}

// Модификаторы.
public extension PageObjectElementRegistrar {
    
    // Если локатор указывает на неуникальный элемент,
    // то подчеркивайте это в названии элемента. Так как это является контрактом.
    //
    // Пример:
    //
    //  public var anyAbuseCategory: ViewElement {
    //      return any.element("Причина жалобы") { element in
    //          element.id == "labelSelectionMultilineFormItem"
    //      }
    //  }
    var any: PageObjectElementRegistrar {
        return atIndex(0)
    }
    
    // Если заведомо известно, что элемент всегда будет на экране, то можно
    // указать это сразу в Page Object. В общем-то, модификатор пока что довольно
    // бесполезный при определении в Page Object (более полезен при использовании
    // в теле теста), так как не влияет на скорость тестирования.
    // Единственное что он дает - это то, что отключится скролл. И если элемент не виден без скролла,
    // то проверка или действие зафейлится. Так мы можем проверить, что элемент всегда доступен без скролла.
    //
    // Пример:
    //
    //  public var button: ButtonElement {
    //      return currentlyVisible.element("кнопка алерта") { element in
    //          element.isInstanceOf(UIButton.self) && element.isSubviewOf { element in
    //              element.id == "alert.button"
    //          }
    //      }
    //  }
    var currentlyVisible: PageObjectElementRegistrar {
        return with(searchMode: .useCurrentlyVisible)
    }
    
    // Для обращения к N-ному элементу в иерархии. Можно подчеркнуть это в названии,
    // например назвать элемент не saveSearchCell, а firstSaveSearchCell.
    // Или создать функцию с индексом в качестве аргумента.
    //
    // Обратите внимание, что позиция в иерархии не гарантирует визуальное расположение
    // элемента в иерархии. То есть первый элемент может быть ниже второго.
    //
    //  public var firstSaveSearchCell: LabelElement {
    //      return atIndex(0).element("параметры сохраненного поиска") { element in
    //          element.id == "TTTAttributedLabel"
    //      }
    //  }
    func atIndex(_ index: Int) -> PageObjectElementRegistrar {
        return with(interactionMode: .useElementAtIndexInHierarchy(index))
    }
    
    // Модификатор заставляет "поискать" элемент двумя свайпами вверх и двумя вниз.
    // Это оригинальное поведение MVP версии.
    //
    // ВНИМАНИЕ: Использовать в случае крайней необходимости.
    // Реализация и поведение изменится.
    // Тесты, зависящие от этого поведения, будут исправлены.
    var accessibleViaBlindScroll: PageObjectElementRegistrar {
        return with(searchMode: .scrollBlindly)
    }
}
