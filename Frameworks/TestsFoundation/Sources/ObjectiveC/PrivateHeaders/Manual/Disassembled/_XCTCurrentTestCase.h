// It is possible to rewrite this in Swift:
//
// @_silgen_name("_XCTCurrentTestCase")
// public func _XCTCurrentTestCase() -> AnyObject?
//
// However, tests were crashing with EXC_BAD_ACCESS on a real app project.

id _XCTCurrentTestCase(void);
