import Foundation

/// Provides type safety by not allowing for example to pass an Int that is not
/// an ID into a function that expects an ID.
public struct Tagged<Tag, RawValue> {
  public let rawValue: RawValue
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension Tagged: Codable where RawValue: Codable {}
extension Tagged: Equatable where RawValue: Equatable {}
extension Tagged: Hashable where RawValue: Hashable {}
extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: RawValue.IntegerLiteralType) {
    self.init(rawValue: RawValue(integerLiteral: value))
  }
  public typealias IntegerLiteralType = RawValue.IntegerLiteralType
}
