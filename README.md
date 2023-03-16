# OpenFeature Swift SDK

Swift implementation of the OpenFeature SDK.

## Usage

### Adding the package dependency

If you manage dependencies through Xcode go to "Add package" and enter `git@github.com:spotify/openfeature-swift-sdk.git`.

If you manage dependencies through SPM, in the dependencies section of Package.swift add:
```swift
.package(url: "git@github.com:spotify/openfeature-swift-sdk.git", from: "0.1.0")
```

and in the target dependencies section add:
```swift
.product(name: "OpenFeature", package: "openfeature-swift-sdk"),
```

### Resolving a flag

To enable the provider and start resolving flags add the following:

```swift
import OpenFeature

// Change this to your actual provider
OpenFeatureAPI.shared.setProvider(provider: NoOpProvider())

let client = OpenFeatureAPI.shared.getClient()
let value = client.getBooleanValue(key: "flag", defaultValue: false)
```

## Development

Open the project in Xcode and build by Product -> Build.

### Linting code

Code is automatically linted during build in Xcode, if you need to manually lint:
```shell
brew install swiftlint
swiftlint
```

### Formatting code

You can automatically format your code using:
```shell
./scripts/swift-format
```

## Running tests from cmd-line

```shell
swift test
```
