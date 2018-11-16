# How-To Private API

We used class-dump to generate headers for frameworks, we used disassembler to reveal behavior of proprietary code and also some signatures of C-functions (class-dump works only for Obj-C).

Pure class-dump is not enough to make good headers, we have a script `dump.py` that generates headers of XCTest and patches output of class-dump. It can be used when new Xcode is released and there are changes in APIs. Currently multiple XCode versions are supported.

## class-dump

Install:

`brew install classdump`

Location of framework by its name (sorted):

```
find /Applications/Xcode.app -type d -name "*.framework"|grep -E "framework$"|perl -pe 's/(^.*?\/)([^\/]+?)(\.framework)/\2: \1\2\3/'|sort
```

Location of specific framework by its name (sorted):
```
find /Applications/Xcode.app -type d -name "*.framework"|grep "XCTest"
```

Here are ready to use shell one-liners that are store headers to some folder (`~/src/Headers/` in examples)

- XCTest, Xcode 9/10:

```
class-dump -o ~/src/Headers/XC10/XCTest -H /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks/XCTest.framework
```

### Reverse engineering

I personally use Hopper Disassembler to disassemble code. It had free plan.

It can generate human readable code like this:

```
/* @class XCUIScreen */
+(void *)mainScreen {
    rbx = [[self screens] retain];
    r14 = [[rbx firstObject] retain];
    [rbx release];
    rax = [r14 autorelease];
    return rax;
}
```

Why would you use it? Sometimes you can't just call a private function, you have to set up state and it can be sophisticated. With disassembler you can see what Apple did and do the same.