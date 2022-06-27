# Republished

@Republished is a proprty wrapper which allows an `ObservableObject` nested
within another `ObservableObject` to notify SwiftUI of changes.

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
of inner `ObservableObjects` that it actually accesses.
