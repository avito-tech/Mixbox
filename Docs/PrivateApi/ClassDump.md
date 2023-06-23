# class-dump

`class-dump` is an OSS for getting Objective-C headers from binaries.

Installation options:

- `brew install classdump` (became unavailable at some point, checked on 2023.06.22)
- Fork with recent updates: `brew install manicmaniac/tap/class-dump` (failed to work on UIKitCore, checked on 2023.06.22)
- Other means of obtaining it.

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

Limitations:

- Can generate code that won't compile (there are multiple issues with it)
- Doesn't generate C declarations (see `class-dump alternative for C code` below)
- Can not be mixed with public headers of same framework properly (declarations will be duplicated)

The `dump.py` is a script that automates dumping private headers and it makes everything work by a lot of postprocessing, see [DumpPy.md](DumpPy.md).

## class-dump alternative for C code

- Search for headers in the internet (example: we use IOKit hearers from webkit OSS)
- Use Hopper or other disassembler (see [Disassembling.md]([Disassembling.md]))
- I don't know if theres some software for dumping C code declarations, it can be, I just didn't need it.
