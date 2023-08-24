import Combine
import Foundation
import SwiftUI

/// Proxy an `Optional` `ObservableObject`'s objectWillChange emissions.
struct OptionalProxy<Source: ObservableObject>: ObservableProxy {

  // MARK: Lifecycle

  init(_ initial: Source?) {
    self.subject = .init(initial)
  }

  // MARK: Internal

  typealias Storage = Source?

  var underlying: Source? {
    get {
      subject.value
    }
    nonmutating set {
      subject.value = newValue
    }
  }

  var objectWillChange: some Publisher<Void, Never> {
    // A publisher emitting based on 2 upstreams...
    Publishers.Merge(
      // ... one which republishes the underlying observable object's objectWillChange (if it
      // exists).
      subject
        .compactMap { $0 }
        .flatMap(\.objectWillChange)
        .map { _ in () },
      // ... one which publishes every time the optional underlying object changes.
      subject
        .removeDuplicates(by: Equate<Source?, Source?>.it)
        .map { _ in () }
    )
  }

  // MARK: Private

  private let subject: CurrentValueSubject<Source?, Never>

}
