import Foundation

struct Dependencies {
  var dataManager: DataManager
  var apiClient: APIClient

  static var liveValues = Dependencies(
    dataManager: .liveValue,
    apiClient: .liveValue
  )
}
