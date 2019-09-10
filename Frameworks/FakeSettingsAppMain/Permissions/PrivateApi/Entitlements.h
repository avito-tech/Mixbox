void * _Nullable SecTaskCopyValueForEntitlement(
                                                void * _Nullable task,
                                                _Nullable CFStringRef entitlement,
                                                CFErrorRef _Nullable * _Nullable error
                                                );

void * _Nullable SecTaskCreateFromSelf(
                                       _Nullable CFAllocatorRef allocator
                                       );

NSObject * _Nullable getEntitlementValue(
                                         _Nullable CFStringRef entitlementKey
                                         );
