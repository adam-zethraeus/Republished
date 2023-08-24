import Republished
import SwiftUI

@MainActor
final class ArrayExampleViewModel: ObservableObject {

  // MARK: Lifecycle

  init(models: [DomainModel]) {
    _models = .init(wrappedValue: models)
  }

  // MARK: Internal

  var info: String {
    "across \(models.count) models"
  }

  var count: String {
    "\(models.map(\.count).reduce(0, +))"
  }

  func incrementAll() {
    for model in models {
      model.set(count: model.count + 1)
    }
  }

  func decrementAll() {
    for model in models {
      model.set(count: model.count - 1)
    }
  }

  func zeroAll() {
    for model in models {
      model.set(count: 0)
    }
  }

  // MARK: Private

  // Here the @Republished property wrapper is used *instead* of
  // an @Published property wrapper and hold the nested ObservableObjects.
  // (Note that there are no @Published wrappers in this file.)

  // @Republished listens to all of its inner ObservableObjects's
  // change notifications and propagates them to this containing ObservableObject.

  // SwiftUI views can use properties here derived from the inner object
  // just as they would use an @Published field.

  @Republished private var models: [DomainModel]

}
