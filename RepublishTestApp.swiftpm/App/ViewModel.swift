import SwiftUI

@MainActor
final class ViewModel: ObservableObject {
    
    @Republished var model = DomainModel()
    
    var info: String {
        [
            model.isEven ? "even" : nil,
            model.isZero ? "zero" : nil,
            model.isNegative ? "negative" : nil,
            model.isPositive ? "positive" : nil,
            model.isMax ? "MAXINT" : nil,
            model.isMin ? "MININT" : nil,
            model.isPrime ? "prime" : nil
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
