# Republished

The `@Republished` proprty wrapper allows an `ObservableObject` nested
within another `ObservableObject` to naturally notify SwiftUI of changes.

It was inspired by [@mergesort's](https://github.com/mergesort) [blog post](https://build.ms/2022/06/22/model-view-controller-store/) introducing [`Boutique`](https://github.com/mergesort/Boutique).

## Problem
Nested `ObservableObjects` don't play well with SwiftUI.

An `ObservableObject` is a reference type, not a value type. This means a field on an outer `ObservableObject` containing an inner `ObservableObject` *doesn't change* when the inner object's one's changes. As such the outer object will not send the `objectWillChange` notification required for SwiftUI to know to rerender views that depend on its data.

Nested `ObservableObjects` are often a sign your data model needs some refactoring — but it can also be a nice way to separate code concerns. [`Boutique`](https://github.com/mergesort/Boutique) provides a data store as a nestable `ObservableObject`. This repo's [Example App](https://github.com/adam-zethraeus/Republished/tree/main/RepublishTestApp.swiftpm) uses nested `ObservableObjects` to separate its 'DomainModel' from its 'ViewModel', showcasing a version of the MVVM pattern that separates view-display logic from business logic (and is a bit closer to its [original form](https://docs.microsoft.com/en-us/xamarin/xamarin-forms/enterprise-application-patterns/mvvm)).

## Usage

The outer `ObservableObject` should hold the inner one in a var annotated
with the `@Republished` property wrapper.

```swift
@Republished private var inner: InnerObservableObject
```

The inner `ObservableObject's` `objectWillChange` notifications will be 
re-emitted by the outer `ObservableObject`, allowing it to provide SwiftUI
compatible accessors derived from the inner.

```swift
var infoFromInner: String { "\(inner.info)" }
```

**Note:** The outer `ObservableObject` will only republish notifications
from inner `ObservableObjects` that it actually accesses.

## SPM

You can use this library via Swift Package Manger by adding a dependency in your Package.swift.

```swift
.package(url: "https://github.com/adam-zethraeus/Republished", from: "0.1.0")
```

## Example App
The [`RepublishedTestApp`](https://github.com/adam-zethraeus/Republished/tree/main/RepublishTestApp.swiftpm) contains a simple example of an [inner `ObservableObject`](https://github.com/adam-zethraeus/Republished/blob/main/RepublishTestApp.swiftpm/App/DomainModel.swift), used by an [outer `ObservableObject`](https://github.com/adam-zethraeus/Republished/blob/main/RepublishTestApp.swiftpm/App/ViewModel.swift) view model, to provide data for a [regular SwiftUI `View`](https://github.com/adam-zethraeus/Republished/blob/main/RepublishTestApp.swiftpm/App/Views/ContentView.swift).
