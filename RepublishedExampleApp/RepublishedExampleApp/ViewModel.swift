import Republished
import SwiftUI

@MainActor
final class ViewModel: ObservableObject {

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

    @Republished private var model: DomainModel

    @Republished private var optionalModel: DomainModel? = nil
    @Republished private var models: [DomainModel] = []

    init(model: DomainModel) {
        _model = .init(wrappedValue: model)
    }

    var info: String {
        [
            model.isEven ? "even" : nil,
            model.isZero ? "zero" : nil,
            model.isNegative ? "negative" : nil,
            model.isPositive ? "positive" : nil,
            model.isMax ? "MAXINT" : nil,
            model.isMin ? "MININT" : nil,
            model.isPrime ? "prime" : nil,
        ]
        .compactMap { $0 }
        .sorted()
        .joined(separator: ", ")
    }

    var countString: String {
        "\(model.count)"
    }

    func increment() {
        model.set(count: model.count + 1)
    }

    func decrement() {
        model.set(count: model.count - 1)
    }

    func rand() {
        model.set(count: Int.random(in: Int.min...Int.max))
    }

    func zero() {
        model.set(count: 0)
    }

}
