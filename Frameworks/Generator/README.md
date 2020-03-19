#  MixboxGenerator

Provides an abstraction for generating something. 

The key class in this framework is Generator. Pseudo-code:

```
class Generator<T> {
    func generate() -> T
}
```

It was originally meant to be a set of tools for generating stubs for tests, but there might be other purposes too.
