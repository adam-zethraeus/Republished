import Combine
import Foundation

protocol ObservableProxy<Storage> {
  associatedtype ObjectWillChangePublisher: Publisher<(), Never>
  associatedtype Storage
  var underlying: Storage { get nonmutating set }
  var objectWillChange: ObjectWillChangePublisher { get }
}
extension ObservableProxy {
  func erase() -> ErasedProxy<Storage> {
    .init(self)
  }
}

struct ErasedProxy<Storage> {
  init(_ p: some ObservableProxy<Storage>) {
    self.objectWillChange = p.objectWillChange.eraseToAnyPublisher()
    self.getUnderlyingFunc = { p.underlying }
    self.setUnderlyingFunc = { p.underlying = $0 }
  }
  let objectWillChange: AnyPublisher<(), Never>
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
