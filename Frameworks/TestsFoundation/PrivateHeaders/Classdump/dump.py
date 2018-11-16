#!/usr/bin/env python3

# How-To:
# Try to run this script.
# Example: ./dump.py --xcode9 /Applications/Xcode9.app/ --xcode10 /Applications/Xcode.app
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

import os
import shutil
import argparse
import re
from enum import Enum

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
    # conditional_compilation_if_clause:
    #   Will be added to the beginning of every header.
    #   Example: "#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120000"
    #
    # path:
    #   Example: /Applications/Xcode.app
    #
    def __init__(self, name, path, conditional_compilation_if_clause):
        self.name = name
        self.conditional_compilation_if_clause = conditional_compilation_if_clause
        self.path = path

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

class PublicTypeWithFramework:
    def __init__(self, name, kind, public_declarations, framework):
        self.name = name
        self.kind = kind
        self.public_declarations = public_declarations
        self.framework = framework
        
class PublicType:
    # `declarations` can be either a list of strings or a newline-separated string.
    # It is easy to copy-paste newline-separated list right from Xcode.
    # See usage.
    def __init__(self, name, kind, public_declarations=[]):
        self.name = name
        self.kind = kind
        
        if isinstance(public_declarations, str):
            self.public_declarations = list(filter(None, public_declarations.split("\n")))
        else:
            self.public_declarations = public_declarations

class Dump:
    def __init__(self):
        self.already_generated_files = set([])
        self.dumped_public_types = self.make_dumped_public_types()
        
    def dumpAll(self):
        args = self.parse_args()
        
        xcodes = [
            Xcode(
                name="Xcode9",
                conditional_compilation_if_clause="#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120000",
                path=args.xcode9
            ),
            Xcode(
                name="Xcode10",
                conditional_compilation_if_clause="#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120000",
                path=args.xcode10
            )
        ]
        
        for xcode in xcodes:
            self.dump(
                framework="Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/PrivateFrameworks/XCTAutomationSupport.framework",
                xcode=xcode
            )
            self.dump(
                framework="Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTest.framework",
                xcode=xcode
            )

    def parse_args(self):
        parser = argparse.ArgumentParser()
        
        parser.add_argument(
            '--xcode9',
            dest='xcode9',
            required=True
        )
        
        parser.add_argument(
            '--xcode10',
            dest='xcode10',
            required=True
        )
    
        return parser.parse_args()

    def dump(self, framework, xcode):
        framework_dir = os.path.join(xcode.path, framework)
        framework_basename = os.path.basename(framework_dir)
        framework_name = re.sub("\.framework$", "", framework_basename)
        
        destination_dir = f"{script_dir}/{framework_name}/{xcode.name}"
        
        if framework_basename == framework_name:
            raise Exception(f"{framework_dir} doesn't seem to be a path to framework! Should have .framework extension.")
    
        shutil.rmtree(destination_dir, ignore_errors=True)
    
        os.system(f'class-dump -o "{destination_dir}" -H "{framework_dir}"')
    
        for entry in os.listdir(destination_dir):
            target_basename = BasenamePatcher.patch_basename(
                basename=entry,
                framework_name=framework_name,
                xcode=xcode
            ) 
            
            source_path = os.path.join(destination_dir, entry)
            target_path = os.path.join(destination_dir, target_basename)
            
            # Remove dumped headers of duplicated classes (e.g. class with same name is generated for different frameworks)
            if target_basename in self.already_generated_files or re.match(r"^NS[A-Z][A-Za-z0-9_]+(-Protocol)?\.h$", entry):
                os.unlink(source_path)
                continue
            self.already_generated_files.add(target_basename)
            
            # We don't need public headers in our private headers.
            public_protocol_files = set([f'{t.name}-Protocol.h' for (n, t) in self.dumped_public_types.items() if t.kind == DeclarationKind.objc_protocol])
            if entry in public_protocol_files:
                os.unlink(source_path)
                continue
                
            contents = self.patch(
                contents=File(path=source_path).read(),
                basename=entry,
                framework_name=framework_name,
                xcode=xcode
            )
            
            os.unlink(source_path)
            
            File(path=target_path).write(
                contents
            )
    
        for entry in os.listdir(destination_dir):
            if entry.endswith("-Protocol.h"):
                file_basename = entry.replace("-Protocol.h", ".h")
                protocol_file = os.path.join(destination_dir, entry)
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
    def make_dumped_public_types(self):
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
        
        types = [
            PublicType(
                name="XCTestCase",
                kind=DeclarationKind.objc_class,
                public_declarations="@property(readonly, copy) NSString *name;",
            ),
            PublicType(
                name="XCTestRun",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCUIScreenshot",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTestCaseRun",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTestSuite",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTestObservationCenter",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTestProbe",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTestRun",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTWaiter",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTestObserver",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTestLog",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTKVOExpectation",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTestSuiteRun",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTNSNotificationExpectation",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTNSPredicateExpectation",
                kind=DeclarationKind.objc_class,
                public_declarations="@property(nonatomic) unsigned long long expectedFulfillmentCount; // @dynamic expectedFulfillmentCount;",
            ),
            PublicType(
                name="XCUIElement",
                kind=DeclarationKind.objc_class,
                public_declarations=
f"""{public_declarations_of_XCUIElementTypeQueryProvider}
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
@property(readonly) XCUIElement *firstMatch;""",
            ),
            PublicType(
                name="XCUIApplication",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCUICoordinate",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCUIDevice",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCUIScreen",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCUISiriService",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="_XCTestCaseInterruptionException",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTAttachment",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTestExpectation",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTDarwinNotificationExpectation",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCUIElementAttributes",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCTest",
                kind=DeclarationKind.objc_class,
                public_declarations=
"""- (void)performTest:(id)arg1;
@property(readonly) XCTestRun *testRun;
@property(readonly) Class testRunClass;
@property(readonly, copy) NSString *name;
@property(readonly) unsigned long long testCaseCount;"""
            ),
            PublicType(
                name="XCTContext",
                kind=DeclarationKind.objc_class
            ),
            PublicType(
                name="XCUIElementAttributes",
                kind=DeclarationKind.objc_protocol
            ),
            PublicType(
                name="XCUIElementTypeQueryProvider",
                kind=DeclarationKind.objc_protocol
            ),
            PublicType(
                name="XCUIElementQuery",
                kind=DeclarationKind.objc_class,
                public_declarations=
f"""{public_declarations_of_XCUIElementTypeQueryProvider}
- (void)performTest:(id)arg1;
@property(readonly) XCTestRun *testRun;
@property(readonly) Class testRunClass;
@property(readonly, copy) NSString *name;
@property(readonly) unsigned long long testCaseCount;"""
            ),
        ]
        
        types_by_name = {}
        
        for t in types:
            types_by_name[t.name] = PublicTypeWithFramework(
                name=t.name,
                kind=t.kind,
                public_declarations=t.public_declarations,
                framework="XCTest"
            )
            
        return types_by_name
        
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
        contents = self.patch_removing_duplicated_declarations(contents=contents, basename=basename, xcode=xcode)

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
        elif basename == "XCElementSnapshot-XCUIElementAttributes.h" or basename == "XCElementSnapshot.h":
            contents = f'#import <XCTest/XCUIElementTypes.h>\n\n{contents}'
            contents = contents.replace("unsigned long long elementType;", "XCUIElementType elementType;")
            contents = contents.replace("unsigned long long _elementType;", "XCUIElementType _elementType;")
            
        return contents
        
    def patch_removing_duplicated_declarations(self, contents, basename, xcode):
        class_name = re.sub(r"(.*?)\.h", "\\1", basename)

        contents = contents + "\n"
        
        common_declarations_to_remove = [
            "@property(readonly, copy) NSString *description;",
            "@property(readonly, copy) NSString *debugDescription;",
            "@property(readonly) unsigned long long hash;",
            "@property(readonly) Class superclass;"
        ]


        if class_name in self.dumped_public_types:
            declarations_to_remove = self.dumped_public_types[class_name].public_declarations + common_declarations_to_remove

            for declaration_to_remove in declarations_to_remove:
                contents = contents.replace(declaration_to_remove + "\n", "")
                
            try:
                public_header = File(path=f"/Applications/Xcode941.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTest.framework/Headers/{class_name}.h")
                public_header_contents = public_header.read()
            except:
                return contents

            properties = re.findall(r'@property.*?([a-zA-Z0-9_]+)(?: [a-zA-Z0-9_]+\(.*?\))?;$', public_header_contents, flags=re.M)
            for property in properties:
                contents = re.sub(fr"@property.*?{property};\n", "", contents)
                # TODO: Handle class and instance properties correctly.
                contents = re.sub(fr"\+ \(.*?\){property};\n", "", contents)
                contents = re.sub(fr"- \(.*?\){property};\n", "", contents)
            
            for method_type in ["-", "\+"]:
                methods = re.findall(fr'(?:^|\n)({method_type} \(.*?;)', public_header_contents, flags=re.S)
            
                for method in methods:
                    method_pattern = method
                    
                    # Remove prefix
                    method_pattern = re.sub(fr"{method_type} \(.*?\)(.*);", "\\1", method_pattern, flags=re.S)
                    
                    # Remove newlines
                    method_pattern = re.sub('\s+', ' ', method_pattern, flags=re.S)
                
                    # Remove annotations like: XCT_UNAVAILABLE("Use XCUIElementQuery to create XCUIElement instances.")
                    method_pattern = re.sub(r"[A-Za-z0-9_]\(.*?\)$", "", method_pattern, flags=re.M)
                    # Remove annotations like: NS_UNAVAILABLE
                    method_pattern = re.sub(r" [A-Za-z0-9_]+$", "", method_pattern, flags=re.M)
                
                    old_value=None
                    while "(" in method_pattern and method_pattern != old_value:
                        old_value = method_pattern
                        method_pattern = re.sub(r":\(.*?( [a-zA-Z0-9_]+?:|$)", ":.*?\\1", method_pattern)

                    method_pattern = re.sub(r":[^:]+$", ":.*", method_pattern)
                
                    method_pattern = fr'^{method_type} (.*?){method_pattern}$'
                
                    # Escape
                    method_pattern = method_pattern.replace("(", "\\(")
                    method_pattern = method_pattern.replace(")", "\\)")
                
                    contents = re.sub(method_pattern, "", contents, flags=re.M)
    
        return contents
        
    def patch_replacing_unknown_types(self, contents, xcode):
        contents = re.sub(
            r'((const )?struct __AXUIElement) \*', 
            '/* unknown type (\\1) */ void *', 
            contents
        )
        
        return contents
        
    def patch_removing_duplicated_newlines(self, contents, xcode):
        contents = re.sub(
            r'\n{2,}', 
            '\n\n', 
            contents,
            flags=re.S
        )
        return contents
        
    def patch_fixing_classdump_bugs(self, contents, xcode):
        # id <XCTestManager_IDEInterface><NSObject> => id <XCTestManager_IDEInterface>
        contents = re.sub(
            r'(id <.*?>)<.*?>', 
            '\\1', 
            contents
        )
        return contents
            
    def patch_making_imports_more_beautiful(self, contents, xcode):
        imports = re.findall(r'(#import .*)', contents)
        
        imports = sorted(set(imports))
        
        contents = re.sub(
            r'(#import .*)', 
            '',
            contents
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
                fr'@{declaration_type} .+?;', 
                '',
                contents
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
                fr'struct {struct} {{.*?}};', 
                '', 
                contents,
                flags=re.S
            )
    
        return contents
        
    def patch_replacing_declarations_of_public_classes_with_categories(self, contents, xcode):
        for (name, public_class) in self.dumped_public_types.items():
            contents = re.sub(
                fr'(@interface {public_class.name}) : [A-Z].*', 
                '\\1 ()', 
                contents
            )
            
        return contents
        
    def patch_appending_destination_to_imports(self, contents, framework_name, xcode):
        basename_patcher = BasenamePatcher(
            framework_name=framework_name,
            xcode=xcode,
            format='#import "{header}"'
        ) 
    
        contents = re.sub(
            r'#import "(.*?\.h)"', 
            basename_patcher.patch_match, 
            contents
        )
        return contents
        
    def patch_replacing_imports_of_public_headers_with_imports_of_private_headers(self, contents, xcode):
        contents = re.sub(
            r'#import <XCTest/(.*?)>', 
            f'#import "\\1"', 
            contents
        )
        contents = re.sub(
            r'#import <XCTAutomationSupport/(.*?)>', 
            f'#import "\\1"', 
            contents
        )
        
        return contents
            
    def patch_removing_strings(self, contents, xcode):
        code_to_remove = [
            '- (void).cxx_destruct;\n',
            '<OS_dispatch_queue>',
            '<OS_dispatch_semaphore>',
            '<OS_xpc_object>'
        ]
        
        for code in code_to_remove:
            contents = contents.replace(code, '')
            
        return contents

    def patch_replacing_imports_of_private_headers_with_imports_of_public_headers(self, contents, xcode):
        import_by_prefix = {
            "NS": "<Foundation/Foundation.h>",
            "UI": "<UIKit/UIKit.h>",
        }
        
        for prefix, imported_header in import_by_prefix.items():
            contents = re.sub(
                fr'#import "{prefix}[A-Z].*?\.h"', 
                f'#import {imported_header}', 
                contents
            )

        for (name, public_class) in self.dumped_public_types.items():
            contents = re.sub(
                fr'#import "{public_class.name}\.h"', 
                f'#import <{public_class.framework}/{public_class.name}.h>', 
                contents
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
