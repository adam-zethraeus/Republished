import Combine
import Foundation
import SwiftUI

/// @Republished is a property wrapper which allows an `ObservableObject` nested
/// within another `ObservableObject` to notify SwiftUI of changes.
///
/// The outer `ObservableObject` should hold the inner one in a var annotated
/// with this property wrapper.
///
/// ```swift
/// @Republished private var inner: InnerObservableObject
/// ```
///
/// The inner `ObservableObject's` `objectWillChange` notifications will be
/// re-emitted by the outer `ObservableObject` allowing it to provide accessors
/// derived from the inner one's values.
///
/// ```swift
/// var infoFromInner: String { "\(inner.info)" }
/// ```
///
/// You can republish from a single ObservableObject, an optional one, or an array of them.
///
/// ```swift
/// @Republished private var inner: InnerObservableObject
/// @Republished private var innerOptional: InnerObservableObject?
/// @Republished private var innerArray: [InnerObservableObject]
/// ```
///
/// > Note: The outer `ObservableObject` will only publish if it is accessed at runtime.
/// > i.e. An unused `@Republished` field doesn't create any underlying subscriptions.
@MainActor
@propertyWrapper
public final class Republished<Wrapped> {

  // MARK: Lifecycle

  public init(wrappedValue: Wrapped) where Wrapped: ObservableObject {
    self.proxy = PassthroughProxy(wrappedValue).erase()
  }

  public init<T: ObservableObject>(wrappedValue: T?) where Wrapped == T? {
    self.proxy = OptionalProxy(wrappedValue).erase()
  }

  public init<T: ObservableObject>(wrappedValue: [T]) where Wrapped == [T] {
    self.proxy = ArrayProxy(wrappedValue).erase()
  }

  // MARK: Public

  public var wrappedValue: Wrapped {
    fatalError("Republished can only be used within an ObservableObject")
  }

  public var projectedValue: Binding<Wrapped> {
    Binding {
      self.proxy.underlying
    } set: { newValue in
      self.proxy.underlying = newValue
    }
  }

  public static subscript<
    Instance: ObservableObject
  >(
    _enclosingInstance instance: Instance,
    wrapped _: KeyPath<Instance, Wrapped>,
    storage storageKeyPath: KeyPath<Instance, Republished>
  )
    -> Wrapped where Instance.ObjectWillChangePublisher == ObservableObjectPublisher
  {
    let storage = instance[keyPath: storageKeyPath]

    if storage.cancellable == nil {
      storage.cancellable = storage
        .proxy
        .objectWillChange
        // Proxies publish first on subscribe, but that happens in a read — which is during a view
        // update.
        .dropFirst()
        .sink { [objectWillChange = instance.objectWillChange] in
          objectWillChange.send()
        }
    }

    return storage.proxy.underlying
  }

  // MARK: Private

  private let proxy: ErasedProxy<Wrapped>
  private var cancellable: AnyCancellable?

}
