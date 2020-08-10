import MixboxFoundation

public protocol ElementFactory: class {
    // These functions designed to be implemented by classes, not to be used in tests.
    //
    // See protocol extensions for client interface (your tests).
    //
    func element<T>(
        name: String,
        factory: (PageObjectElementCore) -> T,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    
    func with(scrollMode: ScrollMode?) -> ElementFactory
    func with(interactionMode: InteractionMode?) -> ElementFactory
    func with(interactionTimeout: TimeInterval?) -> ElementFactory
    func with(percentageOfVisibleArea: CGFloat?) -> ElementFactory
    func with(pixelPerfectVisibilityCheck: Bool?) -> ElementFactory
}

// Convenient functions
public extension ElementFactory {
    func element<T>(
        name: String,
        factory: (PageObjectElementCore) -> T,
        file: StaticString = #file,
        line: UInt = #line,
        function: String = #function,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        return element(
            name: name,
            factory: factory,
            functionDeclarationLocation: FunctionDeclarationLocation(
                fileLine: FileLine(file: file, line: line),
                function: function
            ),
            matcherBuilder: matcherBuilder
        )
    }
    
    func element<T: ElementWithDefaultInitializer>(
        _ name: String,
        file: StaticString = #file,
        line: UInt = #line,
        function: String = #function,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        return element(
            name: name,
            factory: T.init,
            file: file,
            line: line,
            function: function,
            matcherBuilder: matcherBuilder
        )
    }
}

// Modifiers.
public extension ElementFactory {
    
    // Selects any element among elements that are matching.
    //
    // If locator points to an ambiguous element, please, empasize it in the name of a page object element.
    // Because it is a contract of this page object element property.
    //
    // Example:
    //
    //  public var anyCell: ViewElement {
    //      return any.element("Any cell") { element in
    //          element.id == "myCell"
    //      }
    //  }
    var any: ElementFactory {
        return atIndex(0)
    }
    
    // The `withoutScrolling` modifier tells scrolling engine to not scroll.
    // If element is not visible at the moment, check will be failed.
    // Can be useful to check that elements should be visible just after some action.
    //
    // Example:
    //
    //  public var button: ButtonElement {
    //      return withoutScrolling.element("Alert button") { element in
    //          element.isInstanceOf(UIButton.self) && element.isSubviewOf { element in
    //              element.id == "alert.button"
    //          }
    //      }
    //  }
    var withoutScrolling: ElementFactory {
        return with(scrollMode: .some(.none))
    }
    
    // Re-enables default scroll if `scrollMode` was previousely changed.
    var withScrolling: ElementFactory {
        return with(scrollMode: .some(.default))
    }
    
    // This modifier tells to "search" element without knowing where it is.
    // It makes few swipes up and few swipes down. This is a stupid solution,
    // however, it can help you if the element can not be accessed using other measures.
    //
    // Do not use unless default scrolling doesn't work.
    //
    var withBlindScrolling: ElementFactory {
        return with(scrollMode: .some(.blind))
    }
    
    // To point to N-th element. You may want to emphasize this in the name of a variable,
    // for example name the element `firstFoobarCell` istead of `foobarCell`.
    // Or to make a function with an index of element as an argument.
    //
    // Note that the index of element is not related to the position of element is view. For example, visually first element
    // can have higher index than visually second element.
    // You should avoid using it for the purpose other than accessing "any" element.
    //
    // If you have an ordered list in the UI, use `customValues` to set index and access it from test.
    // This will be much more robust than using index of element in hierarchy, which will be a dependence on coincidence.
    //
    // Example:
    //
    //  public var firstFoobarCell: LabelElement {
    //      return atIndex(0).element("The first bar of the foo") { element in
    //          element.id == "foobar"
    //      }
    //  }
    func atIndex(_ index: Int) -> ElementFactory {
        return with(interactionMode: .some(.useElementAtIndexInHierarchy(index)))
    }
}
