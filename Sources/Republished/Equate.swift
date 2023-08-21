import Foundation

/// Helper to equate various ObservableObject wrappers by the identity of their contained ObservableObjects
enum Equate<LHS, RHS> {
  /// Equate arrays of Objects by the contained objects's identity.
  static func it<IdentityType: AnyObject>(_ lhs: [IdentityType], _ rhs: [IdentityType]) -> Bool {
    lhs.map(ObjectIdentifier.init) == rhs.map(ObjectIdentifier.init)
  }
  /// Equate optional Objects — considering two nil values equal.
  static func it<IdentityType: AnyObject>(_ lhs: IdentityType?, _ rhs: IdentityType?) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none): return true
    case (.some, .none), (.none, .some): return false
    case (.some(let lhsObject), .some(let rhsObject)): return lhsObject === rhsObject
    }
  }
}
