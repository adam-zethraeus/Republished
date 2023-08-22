import Combine
import Foundation

// MARK: - ObservableProxy

/// A protocol describing entities which can proxy some underlying
/// `ObservableObject`(s) 'willChange' events, and exposes its
/// ownership of them as `Storage`.
///
/// `Storage` could be a raw `ObservableObject`, or some sort of
/// wrapper.
protocol ObservableProxy<Storage> {
  associatedtype ObjectWillChangePublisher: Publisher<Void, Never>
  associatedtype Storage
  var underlying: Storage { get nonmutating set }
  var objectWillChange: ObjectWillChangePublisher { get }
}

extension ObservableProxy {
  func erase() -> ErasedProxy<Storage> {
    .init(self)
  }
}

// MARK: - ErasedProxy

/// A type erased `ObservableProxy`
///
/// This struct doesn't itself conform to `ObservableProxy`
/// because it's an implementation detail and doesn't
/// really need to!
struct ErasedProxy<Storage> {
  init(_ p: some ObservableProxy<Storage>) {
    self.objectWillChange = p.objectWillChange.eraseToAnyPublisher()
    self.getUnderlyingFunc = { p.underlying }
    self.setUnderlyingFunc = { p.underlying = $0 }
  }

  let objectWillChange: AnyPublisher<Void, Never>
  var underlying: Storage {
    get {
      getUnderlyingFunc()
    }
    nonmutating set {
      setUnderlyingFunc(newValue)
    }
  }

  private let getUnderlyingFunc: () -> Storage
  private let setUnderlyingFunc: (Storage) -> Void
}
