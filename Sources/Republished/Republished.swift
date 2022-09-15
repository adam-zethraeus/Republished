import Combine
import Foundation
import SwiftUI

/// @Republished is a proprty wrapper which allows an `ObservableObject` nested
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
@propertyWrapper
public class Republished<Republishing: ObservableObject>
    where Republishing.ObjectWillChangePublisher == ObservableObjectPublisher {

    private final class CancellableReference {
        var cancellable: AnyCancellable? = nil
    }

    private var republished: Republishing
    private var reference = CancellableReference()

    public init(wrappedValue republished: Republishing)  {
        self.republished = republished
    }

    @MainActor
    public var wrappedValue: Republishing {
        republished
    }

    var republishedSelf: Republished<Republishing> {
        self
    }

    @MainActor
    public var projectedValue: Binding<Republishing> {
        Binding {
            self.republished
        } set: { newValue in
            self.republished = newValue
        }

    }

    @MainActor public static subscript<
        Instance: ObservableObject
    >(
        _enclosingInstance instance: Instance,
        wrapped wrappedKeyPath: KeyPath<Instance, Republishing>,
        storage storageKeyPath: KeyPath<Instance, Republished>
    ) -> Republishing where Instance.ObjectWillChangePublisher == ObservableObjectPublisher {

        let storage = instance[keyPath: storageKeyPath]
        let wrapped = storage.republishedSelf



        if storage.republishedSelf.reference.cancellable == nil {
            storage.republishedSelf.reference.cancellable = wrapped
                .wrappedValue
                .objectWillChange
                .sink(receiveValue: { [objectWillChange = instance.objectWillChange] in
                    objectWillChange.send()
                })
        }

        return wrapped.wrappedValue
    }
}
