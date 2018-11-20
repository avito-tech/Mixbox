#ifndef XC_ALL_SharedHeader_h
#define XC_ALL_SharedHeader_h

@class XCSynthesizedEventRecord, XCElementSnapshot;

typedef void (^XCEventGeneratorHandler)(XCSynthesizedEventRecord *record, NSError *error);
typedef double (^XCUIElementDispatchEventBlock)(XCElementSnapshot *snapshot, XCEventGeneratorHandler handler);

struct __va_list_tag {
    unsigned int _field1;
    unsigned int _field2;
    void *_field3;
    void *_field4;
};

#endif /* XC_ALL_SharedHeader_h */
