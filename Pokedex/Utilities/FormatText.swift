import Foundation

struct FormatString {
  static func removeDash(_ text: String) -> String {
    text.replacingOccurrences(of: "-", with: " ")
  }
}
