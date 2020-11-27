import XCTest

extension XCTestCase {
    // Xcode 12 produces this warning:
    // 'recordFailure(withDescription:inFile:atLine:expected:)' is deprecated: Replaced by 'record(_:)'
    //
    // This warning can't be disabled and we don't want to drop support of Xcode 11,
    // because it doesn't crash when test "Report navigator" is opened.
    //
    // Xcode 12+ has new method - record(_: XCTIssue), Xcode 11 has only old method - recordFailure.
    //
    public func deprecatedRecordFailure(
        withDescription description: String,
        inFile file: String,
        atLine line: Int,
        expected: Bool)
    {
        #if swift(>=5.3)
        // Implementation in XCTest:
        //
        // -(void)recordFailureWithDescription:(void *)arg2 inFile:(void *)arg3 atLine:(unsigned long long)arg4 expected:(bool)arg5 {
        //     r13 = arg5;
        //     r14 = arg4;
        //     rbx = arg3;
        //     var_40 = self;
        //     var_38 = [arg2 retain];
        //     if (rbx != 0x0) {
        //             var_30 = r14;
        //             rbx = [rbx retain];
        //             r14 = [XCTSourceCodeLocation alloc];
        //             r15 = [[NSURL fileURLWithPath:rbx] retain];
        //             [rbx release];
        //             r12 = [r14 initWithFileURL:r15 lineNumber:var_30];
        //             [r15 release];
        //     }
        //     else {
        //             r12 = 0x0;
        //     }
        //     r14 = [[XCTSourceCodeContext alloc] initWithLocation:r12];
        //     r13 = [[XCTIssue alloc] initWithType:((r13 ^ 0x1) & 0xff) + ((r13 ^ 0x1) & 0xff) compactDescription:var_38 detailedDescription:0x0 sourceCodeContext:r14 associatedError:0x0 attachments:**___NSArray0__];
        //     [var_38 release];
        //     [var_40 _recordIssue:r13];
        //     [r13 release];
        //     [r14 release];
        //     [r12 release];
        //     return;
        // }
        record(
            XCTIssue(
                type: expected ? .assertionFailure : .uncaughtException,
                compactDescription: description,
                detailedDescription: nil,
                sourceCodeContext: XCTSourceCodeContext(
                    location: XCTSourceCodeLocation(
                        filePath: file,
                        lineNumber: line
                    )
                ),
                associatedError: nil,
                attachments: []
            )
        )
        #else
        recordFailure(
            withDescription: description,
            inFile: file,
            atLine: line,
            expected: expected
        )
        #endif
    }
}
