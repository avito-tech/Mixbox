# Contributing

## Writing code

```
cd Tests
make pod
open Tests.xcworkspace
```

All changes to Mixbox are made inside that project.

## Testing

Testing is practically impossible on a local machine. It takes several hours to test everything on a local machine.

You can run specific tests. There are BlackBoxTests, GrayBoxTests and UnitTests. Choose a target and run specific tests.

To test compilation of whole project, run linter and unit tests, choose `BuildLintAndUnitTest`, it is a good way to check your changes before making a pull request. Unit tests take few seconds to run.

## Writing CI

```
cd ci/swift
make r
```

Project will be opened if not open or saved and reopened.

`make r` is a shortcut for `make reopen`, and it also doesn't clean caches, so it is faster.

Write code in Xcode, run tests and you are okay to make a pull request.

## Pull request process

There's none at the moment. There was one pull request from community and I just saw it, run tests
in our private CI and merged it by myself via private CI. We have no plans to make public CI, because it is hard.
We have hundreds of mac minis in our company and all tests are executing for few minutes on all mac minis.
We can't make them public.

## Updating Mixbox to support new Xcode

See [documentation](Docs/PrivateApi/DumpPy.md) for [dump.py](Frameworks/TestsFoundation/Sources/PrivateHeaders/Classdump/dump.py)

- See and understand `dump.py`
- Run it for new Xcode
- Run `BuildLintAndUnitTest` scheme in `Tests` project.
- Fix all compilation errors
- Fix all unit tests
