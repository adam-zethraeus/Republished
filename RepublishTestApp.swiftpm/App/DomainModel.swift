import SwiftUI

final class DomainModel: ObservableObject {
    
    @Published private(set) var count: Int = 0
    
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

