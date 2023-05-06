import Foundation

struct Dependencies {
  var dataManager: DataManager
  var apiClient: APIClient

  static var liveValues = Dependencies(
    dataManager: .liveValue,
    apiClient: .liveValue
  )

  static var previewValues = Dependencies(
    dataManager: .mock(),
    apiClient: .mock()
  )
}
