# Contributing

## Writing code

Install required gems. List of gems with desired versions can be found at `ci/gemfiles` 

```
cd Tests
pod install
open Tests.xcworkspace
```

All changes to Mixbox are made inside that project.

## Testing

Testing is practically impossible on a local machine. It tooks 7 hours to test everything on a local machine. We have 70 mac minis and it takes only 20 minutes on average (sometimes 10 minutes).

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
We have 70 mac minis in our company and all tests are executing fo 20 minutes on all mac minis.
We can't make them public.
