#import <UIKit/UIKit.h>

#import "TestedApp-Swift.h"

int main(int argc, char * argv[]) {
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        @throw exception;
    }
}
