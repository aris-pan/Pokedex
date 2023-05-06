import Foundation

struct Current {
  static var dataManager: DataManager = .liveValue
  static var apiClient: APIClient = .liveValue
}
