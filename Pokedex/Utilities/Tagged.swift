import Foundation

/// Provides type safety by not allowing for example to pass an Int that is not
/// an ID into a function that expects an ID.
struct Tagged<Tag, RawValue> {
  let rawValue: RawValue
  init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension Tagged: Codable where RawValue: Codable {}
extension Tagged: Equatable where RawValue: Equatable {}
extension Tagged: Hashable where RawValue: Hashable {}
extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
  init(integerLiteral value: RawValue.IntegerLiteralType) {
    self.init(rawValue: RawValue(integerLiteral: value))
  }
  typealias IntegerLiteralType = RawValue.IntegerLiteralType
}
