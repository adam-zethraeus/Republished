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
/// > Note: The outer `ObservableObject` will only republish notifications
/// > of inner `ObservableObjects` that it actually accesses.
@MainActor
@propertyWrapper
public final class Republished<Republishing: ObservableObject>
    where Republishing.ObjectWillChangePublisher == ObservableObjectPublisher {

    public init(wrappedValue republished: Republishing) {
        self.republished = republished
    }

    public var wrappedValue: Republishing {
        republished
    }

    public var projectedValue: Binding<Republishing> {
        Binding {
            self.republished
        } set: { newValue in
            self.republished = newValue
        }
    }

    public static subscript<
        Instance: ObservableObject
    >(
        _enclosingInstance instance: Instance,
        wrapped _: KeyPath<Instance, Republishing>,
        storage storageKeyPath: KeyPath<Instance, Republished>
    )
        -> Republishing where Instance.ObjectWillChangePublisher == ObservableObjectPublisher {
        let storage = instance[keyPath: storageKeyPath]

        if storage.cancellable == nil {
            storage.cancellable = storage
                .wrappedValue
                .objectWillChange
                .sink { [objectWillChange = instance.objectWillChange] in
                    objectWillChange.send()
                }
        }

        return storage.wrappedValue
    }

    private var republished: Republishing
    private var cancellable: AnyCancellable?

}
