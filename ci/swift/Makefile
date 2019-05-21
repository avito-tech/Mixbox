generate:
	swift package generate-xcodeproj --xcconfig-overrides Package.xcconfig --enable-code-coverage
.PHONY: generate

open: generate
	sleep 2 # To fix "The workspace file at “xxx/ci/swift/MixboxSwiftCI.xcodeproj/project.xcworkspace” has been modified by another application." in Xcode (killing Xcode alone doesn't help; this fix still needs killing Xcode).
	open *.xcodeproj
.PHONY: open

clean:
	swift package clean
	swift package reset
	rm -rf .build/
	rm *.xcodeproj
.PHONY: clean

build:
	swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13" --static-swift-stdlib
.PHONY: build

test:
	swift test -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13"
.PHONY: test
