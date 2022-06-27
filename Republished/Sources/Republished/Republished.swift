import Combine


@propertyWrapper
public struct Republished<Republishing: ObservableObject> where Republishing.ObjectWillChangePublisher == ObservableObjectPublisher {


    private let republished: Republishing
    private var reference = Reference()
    final class Reference {
        var cancellable: AnyCancellable? = nil
    }


    public init(wrappedValue republished: Republishing)  {
        self.republished = republished
    }

    @MainActor
    public var wrappedValue: Republishing {
        republished
    }

    public var projectedValue: Republished<Republishing> {
        self
    }

    @MainActor public static subscript<
        Instance: ObservableObject
    >(
        _enclosingInstance instance: Instance,
        wrapped wrappedKeyPath: KeyPath<Instance, Republishing>,
        storage storageKeyPath: KeyPath<Instance, Republished>
    ) -> Republishing where Instance.ObjectWillChangePublisher == ObservableObjectPublisher {

        let storage = instance[keyPath: storageKeyPath]
        let wrapped = storage.projectedValue.republished
        if storage.projectedValue.reference.cancellable == nil {
            storage.projectedValue.reference.cancellable = wrapped
                .objectWillChange
                .sink(receiveValue: { [objectWillChange = instance.objectWillChange] in
                    objectWillChange.send()
                })
        }

        return wrapped
    }
}
