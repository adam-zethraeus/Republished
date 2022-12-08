import SwiftUI

final class DomainModel: ObservableObject {

    // A standard ObservableObject.

    // Updates to `count` makes the object fire a signal that
    // consumers can listen to to know when to read — and that
    // SwiftUI listens to by default.

    // However, if you nest this in another ObservableObject there's
    // no inbuilt functionality to make the outer one fire for updates
    // in response to this inner one firing.

    // An ObservableObject is a reference type, so an @Published field
    // on the outer object (which contains this object) the field does
    // not actually change.

    @Published private(set) var count = 0

    var isEven: Bool {
        count % 2 == 0
    }

    var isZero: Bool {
        count == 0
    }

    var isNegative: Bool {
        count < 0
    }

    var isPositive: Bool {
        count > 0
    }

    var isMax: Bool {
        count == Int.max
    }

    var isMin: Bool {
        count == Int.min
    }

    var isPrime: Bool {
        switch true {
        case count < 2: return false
        case count < 4: return true
        default:
            return (2...Int(Double(count).squareRoot()))
                .lazy
                .filter { [count] div in
                    count % div == 0
                }
                .first == nil
        }
    }

    func set(count: Int) {
        self.count = count
    }
}
