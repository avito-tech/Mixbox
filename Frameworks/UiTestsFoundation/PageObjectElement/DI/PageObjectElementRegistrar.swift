import MixboxFoundation

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
    func elementImpl<T: ElementWithDefaultInitializer>(
        name: String,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    
    func with(scrollMode: ScrollMode) -> PageObjectElementRegistrar
    func with(interactionMode: InteractionMode) -> PageObjectElementRegistrar
}

// Convenient functions
public extension PageObjectElementRegistrar {
    func element<T: ElementWithDefaultInitializer>(
        _ name: String,
        file: StaticString = #file,
        line: UInt = #line,
        function: String = #function,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        return elementImpl(
            name: name,
            functionDeclarationLocation: FunctionDeclarationLocation(
                fileLine: FileLine(file: file, line: line),
                function: function
            ),
            matcherBuilder: matcherBuilder
        )
    }
}

// Modifiers.
public extension PageObjectElementRegistrar {
    
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
    var any: PageObjectElementRegistrar {
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
    var withoutScrolling: PageObjectElementRegistrar {
        return with(scrollMode: .none)
    }
    
    // Re-enables default scroll if `scrollMode` was previousely changed.
    var withScrolling: PageObjectElementRegistrar {
        return with(scrollMode: .default)
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
    func atIndex(_ index: Int) -> PageObjectElementRegistrar {
        return with(interactionMode: .useElementAtIndexInHierarchy(index))
    }
    
    // This modifier tells to "search" element without knowing where it is.
    // It makes few swipes up and few swipes down. This is a stupid solution,
    // however, it can help you if the element can not be accessed using other measures.
    //
    // Do not use unless default scrolling doesn't work.
    //
    var withBlindScrolling: PageObjectElementRegistrar {
        return with(scrollMode: .blind)
    }
}
