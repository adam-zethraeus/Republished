import Republished
import SwiftUI

@MainActor
final class OptionalExampleViewModel: ObservableObject {

  // MARK: Lifecycle

  init(optionalModel: DomainModel?) {
    _optionalModel = .init(wrappedValue: optionalModel)
  }

  // MARK: Internal

  var info: String {
    [
      optionalModel?.isEven ?? false ? "even" : nil,
      optionalModel?.isZero ?? false ? "zero" : nil,
      optionalModel?.isNegative ?? false ? "negative" : nil,
      optionalModel?.isPositive ?? false ? "positive" : nil,
      optionalModel?.isMax ?? false ? "MAXINT" : nil,
      optionalModel?.isMin ?? false ? "MININT" : nil,
      optionalModel?.isPrime ?? false ? "prime" : nil,
    ]
    .compactMap { $0 }
    .sorted()
    .joined(separator: ", ")
  }

  var countString: String {
    "\((optionalModel?.count).map(String.init) ?? "Optional model is absent!")"
  }

  func increment() {
    guard let model = optionalModel
    else {
      return
    }
    model.set(count: model.count + 1)
  }

  func decrement() {
    guard let model = optionalModel
    else {
      return
    }
    model.set(count: model.count - 1)
  }

  func rand() {
    guard let model = optionalModel
    else {
      return
    }
    model.set(count: Int.random(in: Int.min ... Int.max))
  }

  func zero() {
    guard let model = optionalModel
    else {
      return
    }
    model.set(count: 0)
  }

  // MARK: Private

  // Here the @Republished property wrapper is used *instead* of
  // an @Published property wrapper and hold the nested ObservableObject.
  // (Note that there are no @Published wrappers in this file.)

  // @Republished listens to the inner ObservableObject's
  // change notifications and propagates them to the outer one.

  // SwiftUI views can use properties here derived from the inner object
  // just as they would use an @Published field.
  //
  // This outer object could also provide @Binding surfaces into
  // the inner object's data.

  @Republished private var optionalModel: DomainModel? = nil

}
