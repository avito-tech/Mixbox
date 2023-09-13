# Contributing

## Writing code

```
cd Tests
make open
```

All changes to Mixbox are made inside that project.

## Testing

Testing is practically impossible on a local machine. It takes several hours to test everything on a local machine.

You can run specific tests. There are BlackBoxTests, GrayBoxTests and UnitTests. Choose a target and run specific tests.

To test compilation of whole project, run linter and unit tests, choose `BuildLintAndUnitTest`, it is a good way to check your changes before making a pull request. Unit tests take few seconds to run.

## Writing CI

```
cd ci/swift
make open
```

Project will be opened if not open or saved and reopened.

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

## How Mixbox works

Mixbox is named as such, because the main idea behind it is to support all levels of testing: blackbox/graybox/whitebox.

Mixbox now is mainly about UI testing, though. Blackbox testing is when tests launch app and work with it as with a black box. Graybox testing is when tests run application code directly from tests, open small components like screens or views and test them quickly.

Code for both blackbox and graybox tests is shared. You can reuse same code like page objects in both kinds of tests.

All APIs are the same for both kinds of tests, only implementations are different. Mostly the difference is that in black box tests there are two processes, tests and application, and there is inter-process communication (IPC) between them. And the implementations in gray box tests just use same IPC interfaces, but don't actually do IPC and just call Swift code from Swift code in same process.

