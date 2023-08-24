# Republished ⏩

The `@Republished` proprty wrapper allows an `ObservableObject` nested
within another `ObservableObject` to naturally notify SwiftUI of changes.

## What it achieves

With many patterns with this separation of concerns the developer ends up having to set up manual data bindings between the ViewModel (or Presenter) and the underlying DomainModel (or business logic). 'Reactivity' is hard — and tools used to handle it directly, like RxSwift and Combine, are error prone.

With `@Republished` you can lean into SwiftUI's regular change reponse pipeline and code imperatively — while still keeping your model abstraction layer crisp for your business essential logic.

```swift
struct MyView: View {
  @StateObject var viewModel: MyViewModel

  var body: some View {
    Text(viewModel.myTitle)
  }
}

final class MyViewModel: ObservableObject {

  /// Without Republished SwiftUI would be unaware of changes.

  @Republished var domainModel: MyDomainModel

  var myTitle: String {
    "\(domainModel.beerBottles.count) bottles of beer on the wall!"
  }
}

final class MyDomainModel: ObservableObject {

  /// Essential business logic is kept clean and testable.
  @Published var beerBottles: BeerBottle

  func takeOneDown() {
    beerBottles.removeLast()
  }
}
```

## How it works
Nested `ObservableObjects` don't play well with SwiftUI.

An `ObservableObject` is an identity type, not a value type. This means a field on an outer `ObservableObject` containing an inner `ObservableObject` *doesn't change* when the inner object changes. This means SwiftUI isn't notified of any changes happening and won't update corresponding views.

This package solves this problem by subscibing to the inner object and republishing its change notifications.

## How to get started

### Swift Package Manager
Use this library via Swift Package Manger by adding a dependency in your Package.swift.
```swift
.package(url: "https://github.com/adam-zethraeus/Republished", from: "1.1.1")
```

### Implementation
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

### Additional API Details
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


## Working Examples
The [`RepublishedExampleApp`](https://github.com/adam-zethraeus/Republished/tree/main/RepublishedExampleApp/RepublishedExampleApp) contains an example of an inner `ObservableObject` [domain model](https://github.com/adam-zethraeus/Republished/blob/main/RepublishedExampleApp/RepublishedExampleApp/DomainModel.swift), used by an outer `ObservableObject` [view model](https://github.com/adam-zethraeus/Republished/blob/main/RepublishedExampleApp/RepublishedExampleApp/Single/ViewModel.swift) in a [regular SwiftUI `View`](https://github.com/adam-zethraeus/Republished/blob/main/RepublishedExampleApp/RepublishedExampleApp/Single/ContentView.swift).

It also shows how to use `@Republished` with [optionals](https://github.com/adam-zethraeus/Republished/tree/main/RepublishedExampleApp/RepublishedExampleApp/Optional) and [arrays](https://github.com/adam-zethraeus/Republished/tree/main/RepublishedExampleApp/RepublishedExampleApp/Array) of inner observable objects.

## Credits

This library was inspired by some of the challenges described in a [blog post](https://build.ms/2022/06/22/model-view-controller-store/) by [@mergesort's](https://github.com/mergesort) introducing their the data store library [`Boutique`](https://github.com/mergesort/Boutique).
