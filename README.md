# Republished ⏩

The `@Republished` proprty wrapper allows an `ObservableObject` nested
within another `ObservableObject` to naturally notify SwiftUI of changes.

## Problem
Nested `ObservableObjects` don't play well with SwiftUI.

An `ObservableObject` is an identity type, not a value type. This means a field on an outer `ObservableObject` containing an inner `ObservableObject` *doesn't change* when the inner object changes. This means SwiftUI isn't notified of any changes happening and won't update corresponding views.

This package solves this problem.

### But, consider...
Nested `ObservableObjects` are often a sign that an app's data model needs some love.  
If it's just a state your code has 'ended up in', consider doing some refactoring instead of using `@Republished`.

However: used right `@Republished` can make keeping a nice separation of concerns easier.

This repo's example app uses `ObservableObjects` as 'ViewModels' and 'DomainModels' — decoupling business logic from view logic — and also from the *presentation logic* in the ViewModel.  
It showcases a version of MVVM that allows view-independent business logic modelling — and is a lot closer to MVVM's [original form](https://docs.microsoft.com/en-us/xamarin/xamarin-forms/enterprise-application-patterns/mvvm).

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
final class OuterObservableObject: ObservableObject {
  /* ... */
  @Republished private var inner: InnerObservableObject
  var infoFromInner: String { "\(inner.info)" }
}
```

### Additional API Information

You can also use `@Republished` with an optional `ObservableObject` or an
array of `ObservableObjects`.  
(Note that regular `@StateObject` and `@ObservedObject` do not allow this.)

```swift
final class OuterObservableObject: ObservableObject {
  @Republished private var inner: InnerObservableObject
  @Republished private var optionalInner: InnerObservableObject?
  @Republished private var innerList: [InnerObservableObject]
}
```

### Note

The outer `ObservableObject` will only republish notifications from accessed fields.
If an inner ObservableObject is never touched it will not be subscribed to. (It also
can't be affecting a view if it's not read.)

## Swift Package Manager

You can use this library via Swift Package Manger by adding a dependency in your Package.swift.

```swift
.package(url: "https://github.com/adam-zethraeus/Republished", from: "1.1.1")
```

## Example App
The [`RepublishedExampleApp`](https://github.com/adam-zethraeus/Republished/tree/main/RepublishedExampleApp/RepublishedExampleApp) contains an example of an inner `ObservableObject` [domain model](https://github.com/adam-zethraeus/Republished/blob/main/RepublishedExampleApp/RepublishedExampleApp/DomainModel.swift), used by an outer `ObservableObject` [view model](https://github.com/adam-zethraeus/Republished/blob/main/RepublishedExampleApp/RepublishedExampleApp/Single/ViewModel.swift) in a [regular SwiftUI `View`](https://github.com/adam-zethraeus/Republished/blob/main/RepublishedExampleApp/RepublishedExampleApp/Single/ContentView.swift).

It also shows how to use `@Republished` with [optionals](https://github.com/adam-zethraeus/Republished/tree/main/RepublishedExampleApp/RepublishedExampleApp/Optional) and [arrays](https://github.com/adam-zethraeus/Republished/tree/main/RepublishedExampleApp/RepublishedExampleApp/Array) of inner observable objects.

## Credits

This library was inspired by some of the challenges described in a [blog post](https://build.ms/2022/06/22/model-view-controller-store/) by [@mergesort's](https://github.com/mergesort) introducing their the data store library [`Boutique`](https://github.com/mergesort/Boutique).
