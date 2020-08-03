# UiTestsDemo

This demo shows how you can link Mixbox to your project.

Note that demo doesn't use Cocopods' global spec repo, because this is not how we use it in Avito (Mixbox was developed for testing an application named Avito but it's very configurable for other projects). We use development pods and didn't have time yet to set up CI/CD pipeline to release Mixbox to global spec repo.

We use development pods, because it allows us to test Mixbox temporarily on real app to reproduce some bugs.

## How to use

* pod install
* cmd+U