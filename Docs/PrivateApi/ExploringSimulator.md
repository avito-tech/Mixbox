# Exploring simulator

Simulator has state. Sometimes when you run tests random alerts are shown, like "speed up your typing by sliding your finger across the letters to compose a word".

As of 2021 there's no way to disable them with Apple's tools.

However, we can set up this state, for example, to hide alerts.

To do so, there's a good algorithm.

1. Add simulator directory under git.
2. Prepare UI state before such alert is shown.
3. Commit.
4. Trigger showing of an alert.
5. Commit.
6. Determine what's changed.
7. Implement automation.

## Use cases

- Hiding an alert (for example, adding something to plist)
- Setting up app's permissions (for example, adding something to database)

## Code that may help

### Getting paths for booted devices

```
$ xcrun simctl list -j devices booted|jq -r .devices[][].dataPath
/Users/razinov/Library/Developer/CoreSimulator/Devices/ECD8A977-B3D8-4618-B873-65E495C6069A/data
/Users/razinov/Library/Developer/CoreSimulator/Devices/8ED9D0B9-528C-4821-B934-46FD0787C501/data
```

In this example you need a parent folder of `data` (i.e. `ECD8A977-B3D8-4618-B873-65E495C6069A`), it will contain all files of simulator.

### Committing fast

You should commit changes fast to make them as small as possible. Because simulator periodically does something in its folder and the faster you commit changes, the less irrelevant changes there will be.

```
COMMIT=$((COMMIT+1)); git add . && git commit -m $COMMIT
```
