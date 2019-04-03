// This protocol is used to make abstraction of EarlGrey and XCUI
// Note that UITestCore know nothing about EarlGrey and XCUI,
// so it is just an example.
//
// Instances should return PageObjectElement (see PageObjectElement)
// which provides everything to do with the element and every check.
//
// Later PageObjectElement will become restricted and transform to specific elements:
// - InputElement
// - ButtonElement
// - etc
//
// E.g.: you don't want to type text in button, so you will use ButtonElement, which
// has no ability to type text.
//
// TODO: Rename according to the name of PageObjectElement, which can also be renamed.

public protocol PageObjectElementFactory: class {
    func pageObjectElement(
        settings: ElementSettings)
        -> PageObjectElement
}
