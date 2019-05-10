void * SecTaskCopyValueForEntitlement(void *task, CFStringRef entitlement, CFErrorRef _Nullable *error);
void * SecTaskCreateFromSelf(CFAllocatorRef allocator);

NSObject * getEntitlementValue(CFStringRef entitlementKey);
