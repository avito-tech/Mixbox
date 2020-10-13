# Using dump.py to import private headers of all used private frameworks

`dump.py` is a very silly Python script that can perform [class dump](ClassDump.md) for multiple Xcodes and multiple private frameworks at once, patch sources (because `class-dump` can produce invalid code) and integrate it in Mixbox.

Location: `Frameworks/TestsFoundation/PrivateHeaders/Classdump/dump.py`

1. If you are adding new Xcode, go and add this:

    ```     
    parser.add_argument(
        '--xcode12_0',
        dest='xcode12_0',
        required=False
    )
    ```

2. Then this:

    ```
    Xcode(
        name="Xcode_12_0",
        path=args.xcode12_0,
        ios_min_version=140000,
        ios_max_version=150000, # this is subject to change when new xcode is released
    ),
    ```
    
    Usually it is fine to dump headers of one major release and call it headers for every minor release also. So just use `"Xcode_12_0"` as a name (or whatever version you are using).
    
    We support backward compatibility of headers, so transition from one Xcode to another is smooth. We do it by constraining headers to Xcode version via conditional compilation. The version of Xcode is not determined directly at compile time, instead we use `__IPHONE_OS_VERSION_MAX_ALLOWED`, a latest supported iOS version, which always corresponds to Xcode version (this rule may be violated in the future for obvious reasons, but it is not highly likely).
    
    You don't know the upper limit of iOS version in current version of Xcode, but it is a good idea to just increment min_version by one major version and hope that it will be as usual (major version Xcode being released with support of major version of iOS). You can also just set some very big number, but in this case you will not update headers for new Xcode release, and those might be at least handy to have. Usually, the developers of Xcode don't change much of what we use.

3. Run script:

    ```
    ./Frameworks/TestsFoundation/PrivateHeaders/Classdump/dump.py --xcode12_0 /Applications/Xcode_12_0_1.app
    ```
    
    You can omit previous versions of Xcode. Note that if you are changing rules of how class-dump output is patched, run it also with previous Xcode version to change if there is any diff in generated output.

4. Go to `Tests` folder, run `pod install`, open project and test `BuildLintAndUnitTest` scheme.

5. If you see errors, make everything analogous to what was there before. In my case it was missing `Xcode_12_0_SharedHeader.h`, it is a file that we added manually to support custom code for Xcodes. Just copy paste header from previous Xcode. Or it was missing `Xcode_12_0_DTXProxyChannel.h`, which is actually a bug in the whole system. `dump.py` generates import for this file, but the file is not generated, so we do it manually. But that's not where problems starts.

6. After all this easy stuff you probably can get hundreds of compilation errors:

    - `Unknown type name 'CDUnknownFunctionPointerType'`
    
    I opened the header from previous Xcode and there was just `long long` instead of `CDUnknownFunctionPointerType`. I assumed that it is a pointer and made a typedef in shared header:
    
    ```
    typedef void * CDUnknownFunctionPointerType;
    ```
    
    - `Pointer to non-const type 'id' with no explicit ownership`
    
    This code produced error:
    
    ```
    id *_field2;
    ```
    
    I went to patching part in `dump.py` and decided to just make it `void *` pointer. It is not used at the moment and when it will be used then we can think about it better. I thought that the best existing place for this patch is `patch_replacing_unknown_types`. I've just added one more `re.sub`. All patch functions can be viewed in `def patch(...)` method.
    
    After changing `dump.py` it's safe just to run it again without quitting Xcode or doing `pod install` (maybe not in all cases like changing file structure).
    
    - `Duplicate interface definition for class 'XCTApplicationLaunchMetric'`
    
    This happens when some previously private class becomes public. Find where `PublicTypeEntry` is used and make similar entry:
    
    ```
                PublicTypeEntry(
                    name="XCTApplicationLaunchMetric",
                    kind=DeclarationKind.objc_class,
                    header="XCTMetric.h",
                    public_declarations=
    f'''
    - (id)initWithWaitUntilResponsive:(_Bool)arg1;
    - (id)init;
    ''',
                    ios_min_version=140000
                ),
    ```
    
    - Warnings about missing enum cases in switches.

    I've added `#if compiler(>=5.3)` for code for Xcode 12 and previous versions.
    
    You can omit header if it name doesn't differ from class name. Public declarations are just what is removed from header, so it should be exactly like in the output of `class-dump`. The order is not important, treat it like a newline separated list (it's very convenient, so you can just copypaste code from generated header). Note that there is no way to omit `public_declarations` if declaration is not defined in a separate class, because currently there is no way to parse the header file and remove only a specific declaration (only to remove the entire file).
    
    - Missing private API (if it is changed).
    
    `_symbolicationRecordForTestCode` was missing in XCTestCase. Again, I used `#if compiler(>=5.3)` and found new api (I've searched for `symbolic`).
    
    This is the result (and tests were passing):
    
    ```
    #if compiler(>=5.3)
    // Xcode 12+
    
    // Suppresses `Cast from 'XCTSymbolicationService?' to unrelated type 'XCTInProcessSymbolicationService' always fails` warning.
    let sharedSymbolicationService = XCTSymbolicationService.shared() as AnyObject
    if let symbolicationService = sharedSymbolicationService as? XCTInProcessSymbolicationService {
        // TODO: Assertion error
        let untypedSymbolInfo = symbolicationService.symbolInfoForAddress(inCurrentProcess: stackTraceEntry.address, error: nil)
        
        // TODO: Check if "<unknown>" really applicable here with new API. Write tests.
        if let symbolInfo = untypedSymbolInfo as? XCTSourceCodeSymbolInfo {
            if let location = symbolInfo.location {
                file = location.fileURL.absoluteString == "<unknown>" ? file : location.fileURL.absoluteString
                line = location.lineNumber == 0 ? line : UInt64(location.lineNumber)
            }
            owner = symbolInfo.imageName == "<unknown>" ? owner : symbolInfo.imageName
            symbol = symbolInfo.symbolName == "<unknown>" ? symbol : symbolInfo.symbolName
        }
    }
    #else
    if let record = (XCTestCase()._symbolicationRecordForTestCode(inAddressStack: NSArray(array: [NSNumber(value: stackTraceEntry.address)])) as? XCSymbolicationRecord) ?? (XCSymbolicationRecord.symbolicationRecord(forAddress: stackTraceEntry.address) as? XCSymbolicationRecord) {
        file = record.filePath == "<unknown>" ? file : record.filePath
        line = record.lineNumber == 0 ? line : record.lineNumber
        owner = record.symbolOwner == "<unknown>" ? owner : record.symbolOwner
        symbol = record.symbolName == "<unknown>" ? symbol : record.symbolName
    }
    #endif
    ```

6. After all compilation errors are fixed, fix the tests. Examples:

    - AutomaticCurrentTestCaseProvider was returning `nil` instead of current test case.
    
    I used [Hopper (disassembler)](Disassembling.md), opened XCTest.framework from simulator platform (shipped with Xcode 12) and found this:
    
    ```
    int __XCTCurrentTestCase() {
        return 0x0;
    }
    ```
    
    As we can see here, now this method returns `nil` always.
    
    So I used `#if compiler(>=5.3)` again and add new implementation for Xcode 12. I searched for `currentTest` in Hopper and found that it is a property of `XCTestMisuseObserver`. I found references to this property and it was from the functions of `XCTestObservationCenter`. I found out that `XCTestObservationCenter` is a singleton and holds its observers, so the final code was this:
    
    ```
    let misuseObserver = XCTestObservationCenter
        .shared
        .observers
        .compactMap { $0 as? XCTestMisuseObserver }
        .first
    return misuseObserver?.currentTestCase
    ```
    
    All tests passed on iOS 13 (but one failed on iOS 14: `ObjcRuntimeObjcMethodsWithUniqueImplementationProviderTests` which was very expected). That test has a more or less descriptive message so I just updated switch-case statement and added iOS 14, because it behaves just like iOS 13 in this case. I also made failure message more descriptive for people who don't know what this test is ("the boy scout rule").

