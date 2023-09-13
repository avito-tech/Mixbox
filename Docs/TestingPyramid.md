# Testing pyramid and Mixbox

Mixbox allows you to cover your code on a different levels of [testing pyramid](https://martinfowler.com/articles/practical-test-pyramid.html).

The project follows this terminology:

- **Black box tests**

    Tests are isolated from application, application can not be modified, tests are running in different process and start app like if it was a real app on a user's device (simulator). Mocking is supported only via IPC. They are more high level and slower.
    
    Limitations:
    
    - You can't inject mocks, only to set up them with IPC, which is much harder involves global state.
    
    Pros:
    
    - Easier to write.
    - You can cover a little bit more cases in terms of abilities the tool gives you. For example, you can test starting of application, sending push notifications (only into running app), etc. But note that in practice using black box testing as the only way of testing would require you to write really a lot of tests, because black box tests aren't atomic, for example, if you have 3 * 3 * 3 combinations, you will have to write 27 black box tests (which are slow) and only 9 (and faster) gray box tests, because you will be able to isolate the cases.
    
- **Gray box tests**

    Tests are running in the same process, so tests can inject anything into your DI containers (if you are using DI containers), for example, mocks. If you don't use singletons, you can test your screens in isolation. Tests are very fast, so you can make more tests, make them more atomic (so every test tests few things, but there are a lot of tests and your test coverage is wider). This kind of testing is harder for a QA specialists, but okay for developers of a particular feature.
    
    To make the most out of your gray box tests, I suggest you to have modular architecture, loose coupled code, DI containers, ability to inject anything into anything, ability mock anything, ability to create your UI module from code without using singletons (to make tests independent and without side effects).
    
    Limitations:
    
    - You can't start an app from tests and thus test cases when app is launched (because tests are executed within already launched app).
    - There might be a mess with a global/singleton state (including shared GCD queues, run loops, etc). It can be not a big problem though (as in a real project, Avito).

    Pros:
    
    - They are faster.
    - They are more stable.
    - You can mock everything.

- **White box tests**

    Just unit tests. Ideal unit tests are not linked to an application, they don't use singletons, everything is mocked, everything is synchronous and predictable, everything is running very fast (like milliseconds).
    
    Note about tests being synchronous: those tests are just more stable, but it can be hard for you to implement it (e.g. you are not using RxSwift/Combine and can't easily tweak scheduling of asynchronous tasks so everything become synchronous and predictable; or you don't inject factories of DispatchQueue if you use GCD, or whatever). This is purely optional and is not related to Mixbox in any way. This is just to give you a perspective what good unit tests are.
    
## More about difference between black box and gray box

Black box tests and gray box tests share very similar APIs, but deep inside they have different implementations. You can share a lot of your code between black box and gray box tests.

Here are some stats about speed and stability of black box vs gray box tests from a real application (Avito), as of September 2023.

### Speed

**Black box**: 122 seconds per test on average.

**Gray box**: 6.5 seconds per test on average. Note that we have really high level tests that were just moved from black box tests, that take like 3 minutes to run, that are not atomic and do a lot of things. You can do better, but also you can do whatever you want.

### Stability

**Black box**: We have about 800 of them. They are not stable mainly because they are E2E. We do not run them on PR (in most cases). We have retries and comparison between source and target branch (to eliminate problems where the issue is in infrastructure and not in the source code; tests that are failing on both source and target branch do not block pull request). The comparison to target branch works well and if we run all tests on PR (rarely), PR is not blocked (about 100-200 tests fail, but they are compared to target branch and fail there also and those tests are ignored).

**Gray box**: We run about 4000 tests on PR on a single device/iOS. Some tests (about 50) are marked as flaky and do not block PR. They are more stable than black box tests. They do not use real network. Everything is mocked. Because mocking is very easy to do with this kind of tests. And because of that those tests are more stable. Though, we have a problem with unstable PR builds.
