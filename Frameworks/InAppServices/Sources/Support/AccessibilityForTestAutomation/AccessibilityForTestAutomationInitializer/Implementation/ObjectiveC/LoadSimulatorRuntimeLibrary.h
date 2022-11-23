#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

@import Foundation;

#include <dlfcn.h>

// Returns handle (may be nil).
// Writes error in `error` (may be nil)
static void * loadSimulatorRuntimeLibrary(
                                             NSString *path,
                                             NSString **errorOut)
{
    char const *const localPath = [path fileSystemRepresentation];
    
    void *handle = dlopen(localPath, RTLD_GLOBAL);
    
    if (!handle) {
        char *error = dlerror();
        NSString *suffix = @"";
        
        if (error) {
            suffix = [NSString stringWithFormat:
                      @": %@",
                      [NSString stringWithUTF8String:error]];
        }
        
        if (errorOut) {
            *errorOut = [NSString stringWithFormat:
                         @"dlopen couldn't open %@ at path %s%@",
                         [path lastPathComponent],
                         localPath,
                         suffix];
        }
        
        return NULL;
    } else {
        if (errorOut) {
            *errorOut = nil;
        }
        
        return handle;
    }
}

#endif
