#import "Entitlements.h"
#import <Foundation/Foundation.h>

NSObject * getEntitlementValue(CFStringRef entitlementKey) {
    CFErrorRef err = nil;
    
    NSObject *value = (__bridge NSObject *)(SecTaskCopyValueForEntitlement(SecTaskCreateFromSelf(NULL), entitlementKey, &err));
    
    if (err) {
        NSLog(@"Error in nsNumberEntitlementValue: %@", err);
    }
    
    return value;
}
