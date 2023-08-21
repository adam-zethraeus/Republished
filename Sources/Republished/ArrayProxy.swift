import Combine
import Foundation
import SwiftUI

/// Proxy a `objectWillChange` emissions from an array of  `ObservableObject`s.
struct ArrayProxy<Source: ObservableObject>: ObservableProxy {

  // MARK: Lifecycle

  init(_ initial: [Source]) {
    self.subject = .init(initial)
  }

  // MARK: Internal

  typealias Storage = [Source]

  var underlying: [Source] {
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
      // ... one which publishes whenever any one of the underlying objects's objectWillChange
      // publishes.
      subject
        .flatMap { allUnderlying in
          // Make a publisher which emits when any one of the current underlying ObservableObjects's
          // changes.
          Publishers.MergeMany(
            // Access each of the current ObservableObjects objectWillChange fields.
            allUnderlying
              .map { singleUnderlying in
                singleUnderlying.objectWillChange
              }
          )
        }
        .map { _ in () },
      // ... one which publishes every time the optional underlying object array changes.
      subject
        .removeDuplicates(by: Equate<[Source], [Source]>.it)
        .map { _ in () }
    )
  }

  // MARK: Private

  private let subject: CurrentValueSubject<[Source], Never>

}
