# OpenFeature Swift SDK

![Status](https://img.shields.io/badge/lifecycle-alpha-a0c3d2.svg)

What is OpenFeature?
[OpenFeature][openfeature-website] is an open standard that provides a vendor-agnostic, community-driven API for feature flagging that works with your favorite feature flag management tool.

Why standardize feature flags?
Standardizing feature flags unifies tools and vendors behind a common interface which avoids vendor lock-in at the code level. Additionally, it offers a framework for building extensions and integrations and allows providers to focus on their unique value proposition.

This Swift implementation of an OpenFeature SDK has been developed at Spotify, and currently made available and maintained within the Spotify Open Source Software organization. Part of our roadmap is for the OpenFeature community to evaluate this implementation and potentially include it in the existing ecosystem of [OpenFeature SDKs][openfeature-sdks].

## Requirements

- The minimum iOS version supported is: `iOS 14`.

Note that this library is intended to be used in a mobile context, and has not been evaluated for use in other type of applications (e.g. server applications, macOS, tvOS, watchOS, etc.).

## Usage

### Adding the package dependency

If you manage dependencies through Xcode go to "Add package" and enter `git@github.com:spotify/openfeature-swift-sdk.git`.

If you manage dependencies through SPM, in the dependencies section of Package.swift add:
```swift
.package(url: "git@github.com:spotify/openfeature-swift-sdk.git", from: "0.2.3")
```

and in the target dependencies section add:
```swift
.product(name: "OpenFeature", package: "openfeature-swift-sdk"),
```

### Resolving a flag

```swift
import OpenFeature

// Change NoOpProvider with your actual provider
await OpenFeatureAPI.shared.setProvider(provider: NoOpProvider())

let ctx = MutableContext(
    targetingKey: userId,
    structure: MutableStructure(attributes: ["product": Value.string(productId)]))
await OpenFeatureAPI.shared.setEvaluationContext(evaluationContext: ctx)

let client = OpenFeatureAPI.shared.getClient()
let flagValue = client.getBooleanValue(key: "boolFlag", defaultValue: false)
```

Setting a new provider or setting a new evaluation context are asynchronous operations. The provider might execute I/O operations as part of these method calls (e.g. fetching flag evaluations from the backend and store them in a local cache). It's advised to not interact with the OpenFeature client until the `setProvider()` or `setEvaluationContext()` functions have returned successfully.

Please refer to our [documentation on static-context APIs](https://github.com/open-feature/spec/pull/171) for further information on how these APIs are structured for the use-case of mobile clients.

### Providers

To develop a provider, you need to create a new project and include the OpenFeature SDK as a dependency. You’ll then need to write the provider itself. This can be accomplished by implementing the `FeatureProvider` interface exported by the OpenFeature SDK.


[openfeature-website]: https://openfeature.dev
[openfeature-sdks]: https://openfeature.dev/docs/reference/technologies/
