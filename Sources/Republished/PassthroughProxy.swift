import Combine
import Foundation
import SwiftUI

/// Proxy an `ObservableObject`'s `objectWillChange` emissions.
struct PassthroughProxy<Source: ObservableObject>: ObservableProxy {
  typealias Storage = Source
  init(_ initial: Source) {
    subject = .init(initial)
  }
  var underlying: Source {
    get { subject.value }
    nonmutating set { subject.value = newValue }
  }
  private let subject: CurrentValueSubject<Source, Never>
  var objectWillChange: some Publisher<(), Never>{
    // A publisher emitting based on 2 upstreams...
    Publishers.Merge(
      // ... one which republishes the underlying observable object's objectWillChange.
      subject
        .flatMap { $0.objectWillChange }
        .map { _ in () },
      // ... one which publishes every time the underlying object changes.
      subject
        .removeDuplicates(by: ===)
        .map { _ in () }
    )
  }
}
