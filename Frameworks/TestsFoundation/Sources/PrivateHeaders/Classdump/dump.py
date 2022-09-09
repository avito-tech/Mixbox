#!/usr/bin/env python3

# How-To:
# Try to run this script.
# Example: ./dump.py --xcode10_0 /Applications/Xcode_10_0.app/ --xcode10_1 /Applications/Xcode_10_1.app/ --xcode10_2 /Applications/Xcode.app
#
# In case of errors (either in this script or Xcode when you try to compile the code) see Dump.
# 
# You may want to add new version of Xcode. Append args, add code generation for new xcode (copy and fix existing code).
# Find out suitable conditional compilation #if clauses.
# 
# class-dump output is patched, see `patch`, it is a high-level function, you will see what is happened to code.
#
# Maybe you will add a class that is new in newer version of some framework, add its public interface (we remove public interface from generated headers
# to avoid errors in Xcode about code duplication), etc, etc. Enjoy.

import errno
import os
import shutil
import argparse
import re
from dataclasses import dataclass
from enum import Enum
from typing import Union, List, Dict, Optional

script_dir = os.path.dirname(os.path.realpath(__file__))


class File:
    def __init__(self, path):
        self.path = path

    @staticmethod
    def static_make_dirs(path):
        if not os.path.exists(path):
            try:
                os.makedirs(path)
            except OSError as exc:  # Guard against race condition
                if exc.errno != errno.EEXIST:
                    raise

    def make_dirs(self):
        File.static_make_dirs(
            path=os.path.dirname(self.path)
        )
        
    def read(self):
        with open(self.path) as f:
            string = f.read()
            f.close()
            return string

    def write(self, string):
        self.make_dirs()

        with open(self.path, "w", encoding='utf8') as f:
            f.write(string)
            f.close()


class DeclarationKind(Enum):
    objc_class = "class"
    objc_protocol = "protocol"


class Xcode:
    # name:
    #   Will be used as folder name and a part of header names.
    #   Example: "Xcode9", "Xcode10".
    #
    # path:
    #   Example: /Applications/Xcode.app
    #
    # ios_min_version:
    #   As in __IPHONE_OS_VERSION_MAX_ALLOWED
    #   Example (for iOS 12.2): 120200
    # 
    #
    def __init__(self, name, path, ios_min_version, ios_max_version):
        self.name = name
        self.path = path
        self.ios_min_version = ios_min_version
        self.ios_max_version = ios_max_version

    # Will be added to the beginning of every header.
    # Example: "#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120000"
    @property
    def conditional_compilation_if_clause(self):
        return f"#if __IPHONE_OS_VERSION_MAX_ALLOWED >= {self.ios_min_version} && __IPHONE_OS_VERSION_MAX_ALLOWED < {self.ios_max_version}"
        

class BasenamePatcher:
    def __init__(self, framework_name, xcode, format):
        self.framework_name = framework_name
        self.xcode = xcode
        self.format = format
        
    # To support multiple versions of Xcode (and thus its frameworks) we must
    # create unique files for each Xcode version.
    # When dumping multiple frameworks for a single version of Xcode, files may have same names,
    # The only file that we should keep unique for every framework is CDStructures.h
    #
    # E.g.: XCTest.h => XC10_XCTest.h
    # E.g.: CDStructures.h => XC10_XCTest_CDStructures.h
    @staticmethod
    def patch_basename(basename, framework_name, xcode):
        if basename == "CDStructures.h":
            return f'{xcode.name}_{framework_name}_{basename}'
        else:
            return f'{xcode.name}_{basename}'
        
    def patch_match(self, match):
        return self.format.format(
            header=BasenamePatcher.patch_basename(
                basename=match[1],
                framework_name=self.framework_name,
                xcode=self.xcode
            )
        )


@dataclass
class PublicTypeXcodeVersionDependentInfo:
    name: str
    kind: DeclarationKind
    framework: str
    header: str
    public_declarations: List[str]
    ios_min_version: int
    ios_max_version: int

    # self: 13..14, xcode: 13..14 => matches: true
    # self: 0..100, xcode: 13..14 => matches: true
    # self: 13..14, xcode: 12..13 => matches: false
    def matches(self, xcode: Xcode):
        return self.ios_min_version <= xcode.ios_min_version and self.ios_max_version >= xcode.ios_max_version


@dataclass
class PublicType:
    name: str
    infos: List[PublicTypeXcodeVersionDependentInfo]


@dataclass
class PublicTypes:
    types: Dict[str, PublicType]

    def matching(self, xcode: Xcode) -> List[PublicTypeXcodeVersionDependentInfo]:
        matching = []

        for (_, t) in self.types.items():
            for info in t.infos:
                if info.matches(xcode=xcode):
                    matching.append(info)

        return matching

    def get(self, name: str, xcode: Xcode) -> Optional[PublicTypeXcodeVersionDependentInfo]:
        if name in self.types:
            public_type = self.types[name]

            for info in public_type.infos:
                if info.matches(xcode=xcode):
                    return info

        return None


# List of entries to be easily declared in Python. Actually `PublicType` is used in parsing.
class PublicTypeEntry:
    # `declarations` can be either a list of strings or a newline-separated string.
    # It is easy to copy-paste newline-separated list right from Xcode.
    # See usage.
    def __init__(
        self,
        name: str,
        kind: DeclarationKind,
        header: str = None,
        public_declarations: Union[str, List[str]] = '',
        ios_min_version: int = 0,
        ios_max_version: int = 2147483647
    ):
        self.name = name
        self.kind = kind
        self.ios_min_version = ios_min_version
        self.ios_max_version = ios_max_version
        
        if header is None:
            self.header = f'{name}.h'
        else:
            self.header = header
        
        if isinstance(public_declarations, str):
            self.public_declarations = list(filter(None, public_declarations.split("\n")))
        else:
            self.public_declarations = public_declarations


class RedefinitionKind(Enum):
    struct = "typedef struct"


class RedefinedTypeEntry:
    def __init__(
        self,
        name: str,
        kind: RedefinitionKind,
        header: str = None,
        ios_min_version: int = 0,
        ios_max_version: int = 2147483647
    ):
        self.name = name
        self.kind = kind
        self.ios_min_version = ios_min_version
        self.ios_max_version = ios_max_version
        
        if header is None:
            self.header = f'{name}.h'
        else:
            self.header = header

    def matches(self, xcode: Xcode):
        return self.ios_min_version <= xcode.ios_min_version and self.ios_max_version >= xcode.ios_max_version

class BlacklistedFileEntry:
    def __init__(
        self,
        basename: str,
        ios_min_version: int = 0,
        ios_max_version: int = 2147483647
    ):
        self.basename = basename
        self.ios_min_version = ios_min_version
        self.ios_max_version = ios_max_version

    def matches(self, xcode: Xcode, basename: str):
        return self.matches_xcode(xcode=xcode) and self.basename == basename

    def matches_xcode(self, xcode: Xcode):
        return self.ios_min_version <= xcode.ios_min_version and self.ios_max_version >= xcode.ios_max_version

class Dump:
    def __init__(self):
        self.already_generated_files = set([])
        self.dumped_public_types = self.make_dumped_public_types()
        self.files_to_ignore = [
            BlacklistedFileEntry(
                basename="DTXConnection-XCTestAdditions.h",
                ios_min_version=150000,
                ios_max_version=160000
            ),
            BlacklistedFileEntry(
                basename="XCTExpectedFailure.h",
                ios_min_version=150000,
                ios_max_version=160000
            ),
            BlacklistedFileEntry(
                basename="XCTExpectedFailureOptions.h",
                ios_min_version=150000,
                ios_max_version=160000
            ),
            BlacklistedFileEntry(
                basename="XCTPerformanceMeasurement.h",
                ios_min_version=150000,
                ios_max_version=160000
            ),
        ]
        
    def dumpAll(self):
        args = self.parse_args()
        
        # Note that if you are having troubles with same major version behaving differently
        # on different minor versions, you can change `ios_min_version` and `ios_max_version`
        # to split headers between minor versions (or even patches).
        #
        # I didn't find a way to determine Xcode version in compile time in C directly, so we use supported iOS
        # versions as indicator of Xcode version. It works, because new Xcodes usually support new
        # iOS versions (there was never otherwise for major releases and all currently handled minor versions too
        # but I think it is possible for patches, but usually they don't contain any breaking changes so
        # the general rule of thumb is that Xcode version corresponds to exactly one max iOS version).
        #
        # Note that `#if compiler(>=5.3)` can be used to have a clue about what Xcode is used (in this case it's 12+).
        #
        # Naming is really up to you, because we do not support every Xcode release, and we
        # do not test every Xcode release either. So if you are using for example, Xcode 12.0.1 then
        # you can simply dump headers for it and call it Xcode 12. And hope that everything will work
        # for all minor releases of Xcode 12 (it can work, or otherwise you will know).
        #
        xcodes = [
            Xcode(
                name="Xcode_10_0",
                path=args.xcode10_0,
                ios_min_version=120000,
                ios_max_version=120100,
            ),
            Xcode(
                name="Xcode_10_1",
                path=args.xcode10_1,
                ios_min_version=120100,
                ios_max_version=120200,
            ),
            Xcode(
                name="Xcode_10_2",
                path=args.xcode10_2,
                ios_min_version=120200,
                ios_max_version=120400,
            ),
            Xcode(
                name="Xcode_10_3",
                path=args.xcode10_3,
                ios_min_version=120400,
                ios_max_version=130000,
            ),
            Xcode(
                name="Xcode_11_0",
                path=args.xcode11_0,
                ios_min_version=130000,
                ios_max_version=140000,
            ),
            Xcode(
                name="Xcode_12_0",
                path=args.xcode12_0,
                ios_min_version=140000,
                ios_max_version=150000,
            ),
            Xcode(
                name="Xcode_13_0",
                path=args.xcode13_0,
                ios_min_version=150000,
                ios_max_version=160000, # this is subject to change when new xcode is released
            ),
            Xcode(
                name="Xcode_14_0",
                path=args.xcode14_0,
                ios_min_version=160000,
                ios_max_version=170000,
            ),
        ]
        
        for xcode in xcodes:
            if xcode.path:
                self.dump(
                    framework="Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/PrivateFrameworks/XCTAutomationSupport.framework",
                    xcode=xcode
                )
                self.dump(
                    framework="Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTest.framework",
                    xcode=xcode
                )
                if xcode.ios_min_version >= 150000:
                    self.dump(
                        framework="Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTestCore.framework",
                    xcode=xcode
                )

    def parse_args(self):
        parser = argparse.ArgumentParser()
        
        parser.add_argument(
            '--xcode10_0',
            dest='xcode10_0',
            required=False
        )
        
        parser.add_argument(
            '--xcode10_1',
            dest='xcode10_1',
            required=False
        )
        
        parser.add_argument(
            '--xcode10_2',
            dest='xcode10_2',
            required=False
        )
        
        parser.add_argument(
            '--xcode10_3',
            dest='xcode10_3',
            required=False
        )
        
        parser.add_argument(
            '--xcode11_0',
            dest='xcode11_0',
            required=False
        )
        
        parser.add_argument(
            '--xcode12_0',
            dest='xcode12_0',
            required=False
        )
        
        parser.add_argument(
            '--xcode13_0',
            dest='xcode13_0',
            required=False
        )

        parser.add_argument(
            '--xcode14_0',
            dest='xcode14_0',
            required=False
        )
        
        return parser.parse_args()

    def should_ignore_file(
        self,
        source_path: str, 
        source_basename: str,
        xcode: Xcode
    ) -> bool:
        for file_to_ignore in self.files_to_ignore:
            if file_to_ignore.matches(xcode=xcode, basename=source_basename):
                print(f'Ignoring file {source_basename}')
                os.unlink(source_path)
                return True
        return False

    def dump(
        self,
        framework: str,
        xcode: Xcode
    ):
        framework_dir = os.path.join(xcode.path, framework)
        framework_basename = os.path.basename(framework_dir)
        framework_name = re.sub(
            pattern=r"\.framework$",
            repl="",
            string=framework_basename
        )
        
        destination_dir = f"{script_dir}/{framework_name}/{xcode.name}"
        
        if framework_basename == framework_name:
            raise Exception(f"{framework_dir} doesn't seem to be a path to framework! Should have .framework extension.")
    
        shutil.rmtree(destination_dir, ignore_errors=True)
    
        os.system(f'class-dump -o "{destination_dir}" -H "{framework_dir}"')
    
        for source_basename in os.listdir(destination_dir):
            # print(entry)
            
            target_basename = BasenamePatcher.patch_basename(
                basename=source_basename,
                framework_name=framework_name,
                xcode=xcode
            ) 
            
            source_path = os.path.join(destination_dir, source_basename)
            target_path = os.path.join(destination_dir, target_basename)

            if self.should_ignore_file(source_path, source_basename, xcode):
                continue
            
            # Remove dumped headers of duplicated classes (e.g. class with same name is generated for different frameworks)
            if target_basename in self.already_generated_files or re.match(r"^NS[A-Z][A-Za-z0-9_]+(-Protocol)?\.h$", source_basename):
                os.unlink(source_path)
                continue
            self.already_generated_files.add(target_basename)

            if source_basename in self.entries_to_ignore():
                os.unlink(source_path)
                continue
            
            # We don't need public headers in our private headers.
            public_protocol_files = set(
                [
                    f'{t.name}-Protocol.h'
                    for t in self.dumped_public_types.matching(xcode=xcode)
                ]
            )
            if source_basename in public_protocol_files:
                os.unlink(source_path)
                continue
                
            contents = self.patch(
                contents=File(path=source_path).read(),
                basename=source_basename,
                framework_name=framework_name,
                xcode=xcode
            )
            
            os.unlink(source_path)
            
            File(path=target_path).write(
                contents
            )
    
        for source_basename in os.listdir(destination_dir):
            if source_basename.endswith("-Protocol.h"):
                file_basename = source_basename.replace("-Protocol.h", ".h")
                protocol_file = os.path.join(destination_dir, source_basename)
                class_file = os.path.join(destination_dir, file_basename)
                
                protocol_code = ""
                try:
                    protocol_code = File(path=protocol_file).read()
                except:
                    pass
                    
                class_code = ""
                try:
                    class_code = File(path=class_file).read()
                except:
                    pass
                
                contents = protocol_code + "\n" + class_code
                
                File(path=class_file).write(contents)
                os.unlink(protocol_file)
        
    # How-To: Run this script. Build. For each class copypaste "red lines" (lines with errors about duplicated declarations) here.
    # Declarations that are already public will be removed from generated headers.
    def make_dumped_public_types(self) -> PublicTypes:
        public_declarations_of_XCUIElementTypeQueryProvider = """@property(readonly, copy) XCUIElementQuery *statusItems;
@property(readonly, copy) XCUIElementQuery *otherElements;
@property(readonly, copy) XCUIElementQuery *handles;
@property(readonly, copy) XCUIElementQuery *layoutItems;
@property(readonly, copy) XCUIElementQuery *layoutAreas;
@property(readonly, copy) XCUIElementQuery *cells;
@property(readonly, copy) XCUIElementQuery *levelIndicators;
@property(readonly, copy) XCUIElementQuery *grids;
@property(readonly, copy) XCUIElementQuery *rulerMarkers;
@property(readonly, copy) XCUIElementQuery *rulers;
@property(readonly, copy) XCUIElementQuery *dockItems;
@property(readonly, copy) XCUIElementQuery *mattes;
@property(readonly, copy) XCUIElementQuery *helpTags;
@property(readonly, copy) XCUIElementQuery *colorWells;
@property(readonly, copy) XCUIElementQuery *relevanceIndicators;
@property(readonly, copy) XCUIElementQuery *splitters;
@property(readonly, copy) XCUIElementQuery *splitGroups;
@property(readonly, copy) XCUIElementQuery *valueIndicators;
@property(readonly, copy) XCUIElementQuery *ratingIndicators;
@property(readonly, copy) XCUIElementQuery *timelines;
@property(readonly, copy) XCUIElementQuery *decrementArrows;
@property(readonly, copy) XCUIElementQuery *incrementArrows;
@property(readonly, copy) XCUIElementQuery *steppers;
@property(readonly, copy) XCUIElementQuery *webViews;
@property(readonly, copy) XCUIElementQuery *maps;
@property(readonly, copy) XCUIElementQuery *menuBarItems;
@property(readonly, copy) XCUIElementQuery *menuBars;
@property(readonly, copy) XCUIElementQuery *menuItems;
@property(readonly, copy) XCUIElementQuery *menus;
@property(readonly, copy) XCUIElementQuery *textViews;
@property(readonly, copy) XCUIElementQuery *datePickers;
@property(readonly, copy) XCUIElementQuery *secureTextFields;
@property(readonly, copy) XCUIElementQuery *textFields;
@property(readonly, copy) XCUIElementQuery *staticTexts;
@property(readonly, copy) XCUIElementQuery *scrollBars;
@property(readonly, copy) XCUIElementQuery *scrollViews;
@property(readonly, copy) XCUIElementQuery *searchFields;
@property(readonly, copy) XCUIElementQuery *icons;
@property(readonly, copy) XCUIElementQuery *images;
@property(readonly, copy) XCUIElementQuery *links;
@property(readonly, copy) XCUIElementQuery *toggles;
@property(readonly, copy) XCUIElementQuery *switches;
@property(readonly, copy) XCUIElementQuery *pickerWheels;
@property(readonly, copy) XCUIElementQuery *pickers;
@property(readonly, copy) XCUIElementQuery *segmentedControls;
@property(readonly, copy) XCUIElementQuery *activityIndicators;
@property(readonly, copy) XCUIElementQuery *progressIndicators;
@property(readonly, copy) XCUIElementQuery *pageIndicators;
@property(readonly, copy) XCUIElementQuery *sliders;
@property(readonly, copy) XCUIElementQuery *collectionViews;
@property(readonly, copy) XCUIElementQuery *browsers;
@property(readonly, copy) XCUIElementQuery *outlineRows;
@property(readonly, copy) XCUIElementQuery *outlines;
@property(readonly, copy) XCUIElementQuery *tableColumns;
@property(readonly, copy) XCUIElementQuery *tableRows;
@property(readonly, copy) XCUIElementQuery *tables;
@property(readonly, copy) XCUIElementQuery *statusBars;
@property(readonly, copy) XCUIElementQuery *toolbars;
@property(readonly, copy) XCUIElementQuery *tabGroups;
@property(readonly, copy) XCUIElementQuery *tabs;
@property(readonly, copy) XCUIElementQuery *tabBars;
@property(readonly, copy) XCUIElementQuery *navigationBars;
@property(readonly, copy) XCUIElementQuery *keys;
@property(readonly, copy) XCUIElementQuery *keyboards;
@property(readonly, copy) XCUIElementQuery *popovers;
@property(readonly, copy) XCUIElementQuery *toolbarButtons;
@property(readonly, copy) XCUIElementQuery *menuButtons;
@property(readonly, copy) XCUIElementQuery *comboBoxes;
@property(readonly, copy) XCUIElementQuery *popUpButtons;
@property(readonly, copy) XCUIElementQuery *disclosureTriangles;
@property(readonly, copy) XCUIElementQuery *checkBoxes;
@property(readonly, copy) XCUIElementQuery *radioGroups;
@property(readonly, copy) XCUIElementQuery *radioButtons;
@property(readonly, copy) XCUIElementQuery *buttons;
@property(readonly, copy) XCUIElementQuery *dialogs;
@property(readonly, copy) XCUIElementQuery *alerts;
@property(readonly, copy) XCUIElementQuery *drawers;
@property(readonly, copy) XCUIElementQuery *sheets;
@property(readonly, copy) XCUIElementQuery *windows;
@property(readonly, copy) XCUIElementQuery *groups;
@property(readonly, copy) XCUIElementQuery *touchBars;
@property(readonly) XCUIElement *firstMatch;"""
        
        public_type_entries = [
            PublicTypeEntry(
                name="XCTestCase",
                kind=DeclarationKind.objc_class,
                public_declarations=
"""
@property(readonly, copy) NSString *name;
+ (id)_baselineDictionary;
+ (_Bool)_treatMissingBaselinesAsTestFailures;
+ (id)defaultMetrics;
+ (void)tearDown;
+ (void)setUp;
@property(retain) XCTestCaseRun *testCaseRun; // @synthesize testCaseRun=_testCaseRun;
- (void)addAttachment:(id)arg1;
- (void)registerDefaultMetrics;
- (void)stopMeasuring;
- (void)startMeasuring;
- (void)performTest:(id)arg1;
- (void)invokeTest;
- (Class)testRunClass;
- (id)init;
- (void)removeUIInterruptionMonitor:(id)arg1;
- (id)addUIInterruptionMonitorWithDescription:(id)arg1 handler:(CDUnknownBlockType)arg2;
- (void)nestedWaiter:(id)arg1 wasInterruptedByTimedOutWaiter:(id)arg2;
- (void)waiter:(id)arg1 didFulfillInvertedExpectation:(id)arg2;
- (void)waiter:(id)arg1 fulfillmentDidViolateOrderingConstraintsForExpectation:(id)arg2 requiredExpectation:(id)arg3;
- (void)waiter:(id)arg1 didTimeoutWithUnfulfilledExpectations:(id)arg2;
- (id)expectationForPredicate:(id)arg1 evaluatedWithObject:(id)arg2 handler:(CDUnknownBlockType)arg3;
- (id)expectationForNotification:(id)arg1 object:(id)arg2 notificationCenter:(id)arg3 handler:(CDUnknownBlockType)arg4;
- (id)expectationForNotification:(id)arg1 object:(id)arg2 handler:(CDUnknownBlockType)arg3;
- (id)keyValueObservingExpectationForObject:(id)arg1 keyPath:(id)arg2 handler:(CDUnknownBlockType)arg3;
- (id)keyValueObservingExpectationForObject:(id)arg1 keyPath:(id)arg2 expectedValue:(id)arg3;
- (id)expectationWithDescription:(id)arg1;
- (void)waitForExpectations:(id)arg1 timeout:(double)arg2 enforceOrder:(_Bool)arg3;
- (void)waitForExpectations:(id)arg1 timeout:(double)arg2;
- (void)waitForExpectationsWithTimeout:(double)arg1 handler:(CDUnknownBlockType)arg2;
""",
            ),
            PublicTypeEntry(
                name="XCTestRun",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCUIScreenshot",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTestCaseRun",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTestSuite",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTestObservationCenter",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTestProbe",
                kind=DeclarationKind.objc_class,
                public_declarations=
f"""+ (_Bool)isTesting;"""
            ),
            PublicTypeEntry(
                name="XCTestRun",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTWaiter",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTestObserver",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTestLog",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTKVOExpectation",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTestSuiteRun",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTNSNotificationExpectation",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTNSPredicateExpectation",
                kind=DeclarationKind.objc_class,
                public_declarations="@property(nonatomic) unsigned long long expectedFulfillmentCount; // @dynamic expectedFulfillmentCount;",
            ),
            PublicTypeEntry(
                name="XCUIElement",
                kind=DeclarationKind.objc_class,
                public_declarations=
f"""
{public_declarations_of_XCUIElementTypeQueryProvider}
@property(readonly) long long horizontalSizeClass;
@property(readonly) long long verticalSizeClass;
@property(readonly) unsigned long long elementType;
@property(readonly, copy) NSString *label;
@property(readonly, getter=isSelected) _Bool selected;
@property(readonly, getter=isEnabled) _Bool enabled;
@property(readonly) NSString *identifier;
@property(readonly) NSString *placeholderValue;
@property(readonly, copy) NSString *title;
@property(readonly) struct CGRect frame;
@property(readonly) id value;
@property(readonly) XCUIElement *firstMatch;
@property(readonly, copy) XCUIElementQuery *disclosedChildRows;
@property(readonly) _Bool hasFocus;
""",
            ),
            PublicTypeEntry(
                name="XCUIApplication",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCUICoordinate",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCUIDevice",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCUIScreen",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCUISiriService",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="_XCTestCaseInterruptionException",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTAttachment",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTestExpectation",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTDarwinNotificationExpectation",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCUIElementAttributes",
                kind=DeclarationKind.objc_class
            ),
            PublicTypeEntry(
                name="XCTest",
                kind=DeclarationKind.objc_class,
                public_declarations=
"""- (void)performTest:(id)arg1;
@property(readonly) XCTestRun *testRun;
@property(readonly) Class testRunClass;
@property(readonly, copy) NSString *name;
@property(readonly) unsigned long long testCaseCount;
- (_Bool)tearDownWithError:(id *)arg1;
- (_Bool)setUpWithError:(id *)arg1;
@property(readonly) XCTestRun *testRun; // @synthesize testRun=_testRun;
- (void)tearDownWithCompletionHandler:(CDUnknownBlockType)arg1;
- (void)setUpWithCompletionHandler:(CDUnknownBlockType)arg1;
"""
            ),
            PublicTypeEntry(
                name="XCTContext",
                kind=DeclarationKind.objc_class
            ),
#             PublicTypeEntry(
#                 name="XCElementSnapshot",
#                 kind=DeclarationKind.objc_class,
#                 public_declarations=
# """@property(readonly) XCUIElementType elementType;
# @property(readonly, getter=isEnabled) _Bool enabled;
# @property(readonly) struct CGRect frame;
# @property(readonly) long long horizontalSizeClass;
# @property(readonly) NSString *identifier;
# @property(readonly, copy) NSString *label;
# @property(readonly) NSString *placeholderValue;
# @property(readonly, getter=isSelected) _Bool selected;
# @property(readonly, copy) NSString *title;
# @property(readonly) id value;
# @property(readonly) long long verticalSizeClass;"""
#             ),
            PublicTypeEntry(
                name="XCUIElementAttributes",
                kind=DeclarationKind.objc_protocol
            ),
            PublicTypeEntry(
                name="XCUIElementTypeQueryProvider",
                kind=DeclarationKind.objc_protocol
            ),
            PublicTypeEntry(
                name="XCUIElementQuery",
                kind=DeclarationKind.objc_class,
                public_declarations=
f"""{public_declarations_of_XCUIElementTypeQueryProvider}
- (void)performTest:(id)arg1;
@property(readonly) XCTestRun *testRun;
@property(readonly) Class testRunClass;
@property(readonly, copy) NSString *name;
@property(readonly) unsigned long long testCaseCount;
@property(readonly, copy) XCUIElementQuery *disclosedChildRows;"""
            ),
            PublicTypeEntry(
                name="XCTActivity",
                kind=DeclarationKind.objc_protocol
            ),
            PublicTypeEntry(
                name="XCUIElementSnapshot",
                kind=DeclarationKind.objc_protocol,
                header='XCUIElement.h',
                ios_min_version=130000,
                ios_max_version=140000
            ),
            PublicTypeEntry(
                name="XCUIElementSnapshot",
                kind=DeclarationKind.objc_protocol,
                ios_min_version=0,
                ios_max_version=130000
            ),
            PublicTypeEntry(
                name="XCTestObservation",
                kind=DeclarationKind.objc_protocol
            ),
            PublicTypeEntry(
                name="XCTWaiterDelegate",
                kind=DeclarationKind.objc_protocol,
                header="XCTWaiter.h"
            ),
            PublicTypeEntry(
                name="XCTMetric",
                kind=DeclarationKind.objc_protocol,
                header="XCTMetric.h",
                public_declarations=
f'''
''',
                ios_min_version=130000
            ),
            PublicTypeEntry(
                name="XCTClockMetric",
                kind=DeclarationKind.objc_protocol,
                header="XCTMetric.h",
                public_declarations=
f'''
- (id)initWithApplication:(id)arg1;
''',
                ios_min_version=130000
            ),
            PublicTypeEntry(
                name="XCTCPUMetric",
                kind=DeclarationKind.objc_protocol,
                header="XCTMetric.h",
                public_declarations=
f'''
- (id)initWithApplication:(id)arg1;
''',
                ios_min_version=130000
            ),
            PublicTypeEntry(
                name="XCTMemoryMetric",
                kind=DeclarationKind.objc_protocol,
                header="XCTMetric.h",
                public_declarations=
f'''
- (id)initWithApplication:(id)arg1;
''',
                ios_min_version=130000
            ),
            PublicTypeEntry(
                name="XCTStorageMetric",
                kind=DeclarationKind.objc_protocol,
                header="XCTMetric.h",
                public_declarations=
f'''
- (id)initWithApplication:(id)arg1;
''',
                ios_min_version=130000
            ),
            PublicTypeEntry(
                name="XCTOSSignpostMetric",
                kind=DeclarationKind.objc_protocol,
                header="XCTMetric.h",
                public_declarations=
f'''
- (id)initWithSubsystem:(id)arg1 category:(id)arg2 name:(id)arg3;
''',
                ios_min_version=130000
            ),
            PublicTypeEntry(
                name="XCTPerformanceMeasurementTimestamp",
                kind=DeclarationKind.objc_protocol,
                header="XCTMetric.h",
                public_declarations=
f'''@property(readonly, copy) NSDate *date; // @synthesize date=_date;
@property(readonly) unsigned long long absoluteTime; // @synthesize absoluteTime=_absoluteTime;
@property(readonly) unsigned long long absoluteTimeNanoSeconds;
- (id)initWithAbsoluteTime:(unsigned long long)arg1 date:(id)arg2;
''',
                ios_min_version=130000
            ),
            PublicTypeEntry(
                name="XCTPerformanceMeasurement",
                kind=DeclarationKind.objc_protocol,
                header="XCTMetric.h",
                public_declarations=
f'''@property(readonly, copy) NSString *unitSymbol; // @synthesize unitSymbol=_unitSymbol;
@property(readonly) double doubleValue; // @synthesize doubleValue=_doubleValue;
@property(readonly, copy) NSMeasurement *value; // @synthesize value=_value;
@property(readonly, copy) NSString *displayName; // @synthesize displayName=_displayName;
@property(readonly, copy) NSString *identifier; // @synthesize identifier=_identifier;
- (id)initWithIdentifier:(id)arg1 displayName:(id)arg2 value:(id)arg3;
- (id)initWithIdentifier:(id)arg1 displayName:(id)arg2 doubleValue:(double)arg3 unitSymbol:(id)arg4;
''',
                ios_min_version=130000
            ),
            PublicTypeEntry(
                name="XCTMeasureOptions",
                kind=DeclarationKind.objc_protocol,
                ios_min_version=130000
            ),
            PublicTypeEntry(
                name='XCUIElementSnapshotProviding',
                kind=DeclarationKind.objc_protocol,
                header="XCUIElement.h",
                ios_min_version=120400
            ),
            PublicTypeEntry(
                name='XCUIScreenshotProviding',
                kind=DeclarationKind.objc_protocol,
                header="XCUIElement.h",
                ios_min_version=120400
            ),
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
            PublicTypeEntry(
                name='XCUIElementSnapshot',
                kind=DeclarationKind.objc_protocol,
                header="XCUIElement.h",
                ios_min_version=140000
            ),
            PublicTypeEntry(
                name='XCTIssue',
                kind=DeclarationKind.objc_class,
                ios_min_version=140000
            ),
            PublicTypeEntry(
                name='XCTMutableIssue',
                kind=DeclarationKind.objc_class,
                header="XCTIssue.h",
                ios_min_version=140000,
                public_declarations=
'''
- (void)addAttachment:(id)arg1;
@property(copy) NSArray *attachments;
@property(retain) NSError *associatedError; // @dynamic associatedError;
@property(copy) NSString *compactDescription; // @dynamic compactDescription;
@property(copy) NSString *detailedDescription; // @dynamic detailedDescription;
@property(retain) XCTSourceCodeContext *sourceCodeContext; // @dynamic sourceCodeContext;
@property long long type; // @dynamic type;
''',
            ),
            PublicTypeEntry(
                name='XCTSourceCodeContext',
                kind=DeclarationKind.objc_class,
                ios_min_version=140000
            ),
            PublicTypeEntry(
                name='XCTSourceCodeFrame',
                kind=DeclarationKind.objc_class,
                header="XCTSourceCodeContext.h",
                ios_min_version=140000,
                public_declarations=
'''
@property(readonly) NSError *symbolicationError; // @synthesize symbolicationError=_symbolicationError;
@property(readonly) unsigned long long address; // @synthesize address=_address;
@property(readonly) XCTSourceCodeSymbolInfo *symbolInfo;
- (id)symbolInfoWithError:(id *)arg1;
- (id)initWithAddress:(unsigned long long)arg1 symbolInfo:(id)arg2;
''',
            ),
            PublicTypeEntry(
                name='XCTSourceCodeLocation',
                kind=DeclarationKind.objc_class,
                header="XCTSourceCodeContext.h",
                ios_min_version=140000,
                public_declarations=
'''
@property(readonly) long long lineNumber; // @synthesize lineNumber=_lineNumber;
@property(readonly) NSURL *fileURL; // @synthesize fileURL=_fileURL;
- (id)initWithFilePath:(id)arg1 lineNumber:(long long)arg2;
- (id)initWithFileURL:(id)arg1 lineNumber:(long long)arg2;
''',
            ),
            PublicTypeEntry(
                name='XCTSourceCodeSymbolInfo',
                kind=DeclarationKind.objc_class,
                header="XCTSourceCodeContext.h",
                ios_min_version=140000,
                public_declarations=
'''
@property(readonly) XCTSourceCodeLocation *location; // @synthesize location=_location;
@property(readonly, copy) NSString *symbolName; // @synthesize symbolName=_symbolName;
@property(readonly, copy) NSString *imageName; // @synthesize imageName=_imageName;
- (id)initWithImageName:(id)arg1 symbolName:(id)arg2 location:(id)arg3;
''',
            ),
            PublicTypeEntry(
                name='_XCTSkipFailureException',
                kind=DeclarationKind.objc_class,
                header="XCTestSkippingImpl.h",
                ios_min_version=140000
            ),
        ]

        types_by_name = {}
        
        for entry in public_type_entries:
            public_type: PublicType

            if entry.name not in types_by_name:
                public_type = PublicType(
                    name=entry.name,
                    infos=[]
                )
            else:
                public_type = types_by_name[entry.name]

            public_type.infos.append(
                PublicTypeXcodeVersionDependentInfo(
                    name=entry.name,
                    kind=entry.kind,
                    framework='XCTest',
                    header=entry.header,
                    public_declarations=entry.public_declarations,
                    ios_min_version=entry.ios_min_version,
                    ios_max_version=entry.ios_max_version
                )
            )

            types_by_name[entry.name] = public_type
            
        return PublicTypes(types=types_by_name)
        
    def entries_to_ignore(self):
        return ["XCElementSnapshot-XCUIElementSnapshot.h"]
        
    def patch(self, contents, basename, framework_name, xcode):
        contents = self.patch_removing_strings(contents=contents, xcode=xcode)
        contents = self.patch_removing_public_definitions(contents=contents, xcode=xcode)
        contents = self.patch_fixing_classdump_bugs(contents=contents, xcode=xcode)
        contents = self.patch_replacing_unknown_types(contents=contents, xcode=xcode)

        contents = self.patch_replacing_declarations_of_public_classes_with_categories(contents=contents, xcode=xcode)
        contents = self.patch_adding_missing_forward_declarations_for_used_symbols(contents=contents, xcode=xcode)
        contents = self.patch_adding_missing_imports_for_used_symbols(contents=contents, xcode=xcode)
        contents = self.patch_replacing_imports_of_public_headers_with_imports_of_private_headers(contents=contents, xcode=xcode)
        contents = self.patch_replacing_imports_of_private_headers_with_imports_of_public_headers(contents=contents, xcode=xcode)
        contents = self.patch_removing_duplicated_declarations(contents=contents, basename=basename, framework_path='/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTest.framework/Headers/', xcode=xcode)
        if xcode.ios_min_version >= 150000:
            contents = self.patch_removing_duplicated_declarations(contents=contents, basename=basename, framework_path='/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTestCore.framework/Headers/', xcode=xcode)
        contents = self.patch_removing_redeclarations(contents=contents, basename=basename, framework_name=framework_name, xcode = xcode)

        contents = self.patch_specific_methods(contents=contents, basename=basename, xcode=xcode)

        contents = self.patch_adding_shared_header(contents=contents, xcode=xcode)

        contents = self.patch_making_forward_declarations_more_beautiful(contents=contents, xcode=xcode)
        contents = self.patch_making_imports_more_beautiful(contents=contents, xcode=xcode)

        contents = self.patch_inserting_macros(contents=contents, xcode=xcode)

        contents = self.patch_appending_destination_to_imports(contents=contents, framework_name=framework_name, xcode=xcode)
        contents = self.patch_removing_duplicated_newlines(contents=contents, xcode=xcode)

        return contents    
        
    def patch_specific_methods(self, contents, basename, xcode):
        contents = contents.replace("+ (id)shared", "+ (instancetype)shared")
        
        if basename == "XCEventGenerator.h" or basename == "XCUIEventGenerator.h": # 1: Xcode 9, 2: Xcode 10
            contents = contents.replace("handler:(CDUnknownBlockType)", "handler:(XCEventGeneratorHandler)")
        elif basename == "XCElementSnapshot-XCUIElementAttributes.h" or basename == "XCElementSnapshot.h" or basename == "XCElementSnapshot-Hitpoint.h":
            contents = f'#import <XCTest/XCUIElementTypes.h>\n\n{contents}'
            contents = contents.replace("unsigned long long elementType;", "XCUIElementType elementType;")
            contents = contents.replace("unsigned long long _elementType;", "XCUIElementType _elementType;")

            contents = contents.replace("long long horizontalSizeClass;", "XCUIUserInterfaceSizeClass horizontalSizeClass;")
            contents = contents.replace("long long verticalSizeClass;", "XCUIUserInterfaceSizeClass verticalSizeClass;")
        elif basename == "XCUIElement.h":
            # Xcode 10.1:
            contents = contents.replace(
                "- (void)_dispatchEvent:(id)arg1 block:(CDUnknownBlockType)arg2;",
                "- (void)_dispatchEvent:(id)arg1 block:(XCUIElementDispatchEventBlock)arg2;"
            )
            # Xcode 10.2:
            contents = contents.replace(
                "- (void)_dispatchEvent:(id)arg1 eventBuilder:(CDUnknownBlockType)arg2;",
                "- (void)_dispatchEvent:(id)arg1 eventBuilder:(DispatchEventEventBuilder)arg2;"
            )
            
        return contents

    def patch_removing_redeclarations(
        self,
        contents: str,
        basename: str,
        framework_name: str,
        xcode: Xcode
    ):
        redeclarations_list = [
            RedefinedTypeEntry(
                name = 'CDStruct_70511ce9',
                kind = RedefinitionKind.struct,
                header = 'XCTestCore_CDStructures.h',
                ios_min_version = 150000,
                ios_max_version = 160000
            ),
        ]

        for entry in redeclarations_list:
            full_header_name = fr"{framework_name}_{basename}"
            if full_header_name == entry.header and entry.matches(xcode):
                print(fr"{framework_name}_{basename} == {entry.header}")
                template = r"{[a-zA-Z0-9_\s;\*\[\]\/`.]+}"
                contents = re.sub(
                    pattern=fr"typedef struct {template} {entry.name};",
                    repl="",
                    string=contents,
                    flags=re.M,
                )

        return contents
        
    def patch_removing_duplicated_declarations(
        self,
        contents: str,
        basename: str,
        framework_path: str,
        xcode: Xcode
    ):
        class_name = re.sub(
            pattern=r"(.*?)\.h",
            repl="\\1",
            string=basename,
        )

        contents = contents + "\n"
        
        common_declarations_to_remove = [
            "@property(readonly, copy) NSString *description;",
            "@property(readonly, copy) NSString *debugDescription;",
            "@property(readonly) unsigned long long hash;",
            "@property(readonly) Class superclass;"
        ]

        if class_name == "XCTElementSetCodableTransformer" or class_name == "XCTElementDisclosedChildRowsTransformer":
            # print(f'class_name: {class_name}, contents: {contents}')

            contents = re.sub(
                pattern=r"_Bool _stopsOnFirstMatch;",
                repl="",
                string=contents,
            )
            contents = re.sub(
                pattern=r"NSString \*_transformationDescription;",
                repl="",
                string=contents,
            )

            # print(f'after: {contents}')

        public_type = self.dumped_public_types.get(name=class_name, xcode=xcode)
        if public_type:
            declarations_to_remove = public_type.public_declarations + common_declarations_to_remove
        else:
            declarations_to_remove = common_declarations_to_remove

        for declaration_to_remove in declarations_to_remove:
            if class_name == "XCTest":
                print(fr"{declarations_to_remove} in {class_name}")
            contents = contents.replace(declaration_to_remove + "\n", "")
            
        try:
            public_header = File(path=f"{xcode.path}{framework_path}{class_name}.h")
            public_header_contents = public_header.read()
        except:
            return contents

        properties = re.findall(r'@property.*?([a-zA-Z0-9_]+)(?: [a-zA-Z0-9_]+\(.*?\))?;$', public_header_contents, flags=re.M)
        for property in properties:
            contents = re.sub(
                pattern=fr"@property.*?{property};\n",
                repl="",
                string=contents
            )
            # TODO: Handle class and instance properties correctly.
            contents = re.sub(
                pattern=fr"\+ \(.*?\){property};\n",
                repl="",
                string=contents
            )
            contents = re.sub(
                pattern=fr"- \(.*?\){property};\n",
                repl="",
                string=contents
            )
        
        for method_type in ["-", "\+"]:
            methods = re.findall(fr'(?:^|\n)({method_type} \(.*?;)', public_header_contents, flags=re.S)
        
            for method in methods:
                method_pattern = method
                
                # Remove prefix
                method_pattern = re.sub(
                    pattern=fr"{method_type} \(.*?\)(.*);",
                    repl="\\1",
                    string=method_pattern,
                    flags=re.S
                )
                
                # Remove newlines
                method_pattern = re.sub(
                    pattern=r'\s+',
                    repl=' ',
                    string=method_pattern,
                    flags=re.S
                )
            
                # Remove annotations like: XCT_UNAVAILABLE("Use XCUIElementQuery to create XCUIElement instances.")
                method_pattern = re.sub(
                    pattern=r"[A-Za-z0-9_]\(.*?\)$",
                    repl="",
                    string=method_pattern,
                    flags=re.M,
                )
                # Remove annotations like: NS_UNAVAILABLE
                method_pattern = re.sub(
                    pattern=r" [A-Za-z0-9_]+$",
                    repl="",
                    string=method_pattern,
                    flags=re.M,
                )
            
                old_value=None
                while "(" in method_pattern and method_pattern != old_value:
                    old_value = method_pattern
                    method_pattern = re.sub(
                        pattern=r":\(.*?( [a-zA-Z0-9_]+?:|$)",
                        repl=":.*?\\1",
                        string=method_pattern,
                    )

                method_pattern = re.sub(
                    pattern=r":[^:]+$",
                    repl=":.*",
                    string=method_pattern,
                )
            
                method_pattern = fr'^{method_type} (.*?){method_pattern}$'
            
                # Escape
                method_pattern = method_pattern.replace("(", "\\(")
                method_pattern = method_pattern.replace(")", "\\)")
            
                contents = re.sub(
                    pattern=method_pattern,
                    repl="",
                    string=contents,
                    flags=re.M,
                )
    
        return contents
        
    def patch_replacing_unknown_types(self, contents, xcode):
        contents = re.sub(
            pattern=r'((const )?struct __AXUIElement) \*',
            repl='/* unknown type (\\1) was removed in dump.py */ void *',
            string=contents,
        )
        # `id *` triggers this error: `Pointer to non-const type 'id' with no explicit ownership`
        # We don't want to deal with it. It is clearly a pointer, so let it be `void *` instead.
        # We want to restrict it to structs only:
        # ```
        # typedef struct {
        #     unsigned long long _field1;
        #     id *_field2;
        #     unsigned long long *_field3;
        #     unsigned long long _field4[5];
        # } CDStruct_70511ce9;
        # ```
        # The following code is a workaround to do so. It ignores the fact that variable is defined in a struct.
        # But it works and doesn't do harm. 
        contents = re.sub(
            pattern=r'(\s)id \*(.*?);',
            repl='\\1/* was `id *` before dump.py */ void * \\2;',
            string=contents
        )
        
        return contents
        
    def patch_removing_duplicated_newlines(self, contents, xcode):
        contents = re.sub(
            pattern=r'\n{2,}',
            repl='\n\n',
            string=contents,
            flags=re.S
        )
        return contents
        
    def patch_fixing_classdump_bugs(self, contents, xcode):
        # id <XCTestManager_IDEInterface><NSObject> => id <XCTestManager_IDEInterface>
        contents = re.sub(
            pattern=r'(id <.*?>)<.*?>',
            repl='\\1',
            string=contents
        )
        return contents
            
    def patch_making_imports_more_beautiful(self, contents, xcode):
        imports = re.findall(r'(#import .*)', contents)
        
        imports = sorted(set(imports))
        
        contents = re.sub(
            pattern=r'(#import .*)',
            repl='',
            string=contents
        )
        
        joined_imports = "\n".join(imports)
        
        contents = f'{joined_imports}\n\n{contents}'
            
        return contents
        
    def patch_making_forward_declarations_more_beautiful(self, contents, xcode):
        for declaration_type in ["class", "protocol"]:
            declarations = ", ".join(re.findall(fr'@{declaration_type} (.+?);', contents)).split(", ")
            declarations = list(filter(None, declarations))
            declarations = [
                declaration
                for declaration in declarations
                if not re.match(r"NS[A-Z][A-Za-z0-9_]+", declaration) and not re.match(r"CDStruct_[0-9a-f]{8,}", declaration)
            ]
            declarations = sorted(set(declarations))
            
            contents = re.sub(
                pattern=fr'@{declaration_type} .+?;',
                repl='',
                string=contents
            )
            
            if len(declarations) > 0:
                joined = ", ".join(declarations)
                contents = f'@{declaration_type} {joined};\n\n{contents}'
                
        return contents
            
    def patch_adding_shared_header(self, contents, xcode):
        contents = f'#import "SharedHeader.h"\n\n{contents}'
        contents = f'#import "CDStructures.h"\n\n{contents}'
        
        return contents
        
    def patch_inserting_macros(self, contents, xcode):
        contents = f'{xcode.conditional_compilation_if_clause}\n\n{contents}\n\n#endif'
        
        return contents
        
    def patch_removing_public_definitions(self, contents, xcode):
        public_structs = [
            "CGPoint",
            "CGRect",
            "CGSize",
            "CGVector",
            "time_value",
            "_NSRange",
            # Private/Shared:
            "__va_list_tag"
        ]
        
        for struct in public_structs:
            contents = re.sub(
                pattern=fr'struct {struct} {{.*?}};',
                repl='',
                string=contents,
                flags=re.S
            )
    
        return contents
        
    def patch_replacing_declarations_of_public_classes_with_categories(
        self,
        contents: str,
        xcode: Xcode
    ):
        for info in self.dumped_public_types.matching(xcode=xcode):
            contents = re.sub(
                pattern=fr'(@interface {info.name}) : [A-Z].*',
                repl='\\1 ()',
                string=contents
            )
            
        return contents
        
    def patch_appending_destination_to_imports(self, contents, framework_name, xcode):
        basename_patcher = BasenamePatcher(
            framework_name=framework_name,
            xcode=xcode,
            format='#import "{header}"'
        ) 
    
        contents = re.sub(
            pattern=r'#import "(.*?\.h)"',
            repl=basename_patcher.patch_match,
            string=contents
        )
        return contents
        
    def patch_replacing_imports_of_public_headers_with_imports_of_private_headers(self, contents, xcode):
        contents = re.sub(
            pattern=r'#import <XCTest/(.*?)>',
            repl=f'#import "\\1"',
            string=contents
        )
        contents = re.sub(
            pattern=r'#import <XCTestCore/(.*?)>',
            repl=f'#import "\\1"',
            string=contents
        )
        contents = re.sub(
            pattern=r'#import <XCTAutomationSupport/(.*?)>',
            repl=f'#import "\\1"',
            string=contents
        )
        
        return contents
            
    def patch_removing_strings(self, contents, xcode):
        code_to_remove = [
            '- (void).cxx_destruct;\n',
            '<OS_dispatch_queue>',
            '<OS_dispatch_semaphore>',
            '<OS_xpc_object>',
            '<OS_dispatch_group>',
            '<_XCTMessaging_VoidProtocol>',
        ]
        
        for code in code_to_remove:
            contents = contents.replace(code, '')
            
        return contents

    def patch_replacing_imports_of_private_headers_with_imports_of_public_headers(
        self,
        contents: str,
        xcode: Xcode
    ):
        import_by_prefix = {
            "NS": "<Foundation/Foundation.h>",
            "UI": "<UIKit/UIKit.h>",
        }
        
        for prefix, imported_header in import_by_prefix.items():
            contents = re.sub(
                pattern=fr'#import "{prefix}[A-Z].*?\.h"',
                repl=f'#import {imported_header}',
                string=contents
            )

        for type_info in self.dumped_public_types.matching(xcode=xcode):
            contents = re.sub(
                pattern=fr'#import "{type_info.name}\.h"',
                repl=f'#import <{type_info.framework}/{type_info.header}>',
                string=contents
            )
            
        return contents

    def patch_adding_missing_forward_declarations_for_used_symbols(self, contents, xcode):
        for match in re.findall("id <([A-Z][A-Za-z0-9_]+?)>", contents):
            contents = f'@protocol {match};\n\n{contents}'
            
        for match in re.findall("([A-Z][A-Za-z0-9_]+?) \*", contents):
            if match not in ["Protocol"]:
                contents = f'@class {match};\n\n{contents}'
            
        return contents
        
    def patch_adding_missing_imports_for_used_symbols(self, contents, xcode):
        # Obj-C categories
        for match in re.findall("@interface ([A-Z][A-Za-z0-9_]+?) \(", contents):
            contents = f'#import "{match}.h"\n\n{contents}'
            
        return contents
        
    
Dump().dumpAll()
