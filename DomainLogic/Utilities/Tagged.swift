import Foundation

public struct Tagged<Tag, RawValue> {
  public let rawValue: RawValue
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension Tagged: Codable where RawValue: Codable {}
extension Tagged: Equatable where RawValue: Equatable {}
extension Tagged: Hashable where RawValue: Hashable {}
