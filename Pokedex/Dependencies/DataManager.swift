import Foundation

struct DataManager {
  var load: (URL) throws -> Data
  var save: (Data, URL) throws -> Void
}

extension DataManager {
  static let liveValue = DataManager(
    load: { url in try Data(contentsOf: url) },
    save: { data, url in try data.write(to: url) }
  )
}

extension DataManager {
  private static var data: Data?

  static func mock(initialData: Data? = nil) -> DataManager {
    self.data = initialData
    return DataManager(
      load: { _ in
        guard let data = self.data
        else {
          struct FileNotFound: Error {}
          throw FileNotFound()
        }
        return data
      },
      save: { newData, _ in self.data = newData }
    )
  }
}
