#  MixboxFoundation

Shared simple utilities that are used across all frameworks in this repo.

There is and should be no dependencies in this library.

All functions in extensions of external classes (such as UIView) are prefixed by "mb_" due to https://bugs.swift.org/browse/SR-3908

This approach is not used anywhere else in this repo, but it can be requested if there will be name collisions.
