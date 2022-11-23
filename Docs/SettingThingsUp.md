# How-To set up Mixbox in your project

## If you don't have a project or UI tests

Create new project. If you want to use both kinds of UI testing, black box and gray box (see [TestingPyramid.md](TestingPyramid.md) for terminology and best practices), create different test targets:

- Use "UI tests" template for black box UI testing. Suggested name: `BlackBoxTests`.
- Use "Unit tests" template for gray box UI testing (with "host application"). Suggested name: `GrayBoxTests`.

It's also recommended to not link your unit tests (white box, not gray box tests) with host application, but it's purely optional; it's just an advice.

## Linking Mixbox via Cocoapods

Go to [Demos/UiTestsDemo](../Demos/UiTestsDemo), open `Podfile` and make same things to the Podfile of your project. Note that you can play around it and configure the project as you want. Mandatory things are marked as ones by comments.

Just copy-paste `PodfileUtils` folder. It contains logic of setting up your Pods for using Mixbox. This is the only supported way of distributing Mixbox and this is the way it is used in the Avito app (our organization is called Avito, the code of the app is not open sources). And it has benefits of allowing to test Mixbox as a development pod, use our private repository, you can use your fork, for example, I you want to contribute to the project. This way it is very very easy to contribute and there is no need to distribute the code. This is also optional, but very recommended and supported way.

Do not use Cocoapods' global spec repo, currently the Mixbox is not uploaded there (but it may be changed in future if we have time to make good CI/CD process for delivering Mixbox to main spec repo).

## Make it disabled in production

There are several measures to avoid code leaking into production code:

1. Your code won't link if you misconfigure Mixbox (the source code is in `EnsureReleaseAppIsNotAffected.swift`).
2. Everything is under conditional compilation like `#if MIXBOX_ENABLE_ALL_FRAMEWORKS`.
3. If some file misses conditional compilation clause, then the commit wouldn't pass CI checks and wouldn't be merged into master. So at any given commit there is no chance that something is missed.
4. **The last and the most important:** you shouldn't link Mixbox with your app in your release configuration. This can be done via standard Cocoapods API or via `Devpods` API (as in Demo). But anyway, the code wouldn't leak if you forget something.

## Setting up Mixbox in code

See demo. Make as you wish. The end goal is to instantiate page objects with all dependencies, to set up `MixboxInAppServices`. The idea behind Mixbox is to give you opportunity to wire up everything into existing application as you want, override any dependency if you want to customize something. There are preset DI containers for black box and gray box testing.

If you want to support both kinds of tests it's recommended to share the code of you base testcase classes (inherited from `XCTestCase`), page objects, and other code in a separate framework. Alternatively you can you can just add files to your main project and check both targets (but it will be compiled slower, it would be less reusable, etc).

## Brief description fo steps

- Add schemes and test targets for tests (e.g. gray box and black box tests) as in Demo.
- Wire up Mixbox in Podfile as in Demo.
- Create new or modify your existing TestCase base classesas in Demo.
- Wire up DI as in Demo.
- In your AppDelegate start MixboxInAppServices as in Demo.
- Wire up `ipcClient` from app with your tests as in Demo.
- Set environment in your gray box tests scheme: MIXBOX_IPC_STARTER_TYPE=graybox 
- cmd+U or go to our telegram channel or slack.

Advice:

- Name your base classes `TestCase` in every target. It is short, simple, clear, and will allow you to move your tests across targets, for example, make your black box test a gray box test and vice versa.


## Troubleshooting

- This setting may be (or may be not) required in UI Tests target: `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES` = `YES`
- We recommend you to using Legacy Build System. New build system fails to drop caches properly. I think there was an issue with development pods.
