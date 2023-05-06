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
        guard let data = initialData
        else {
          struct FileNotFound: Error {}
          throw FileNotFound()
        }
        return data
      },
      save: { newData, _ in self.data = newData }
    )
  }

  static func failToWrite(initialData: Data? = nil) -> DataManager {
    self.data = initialData
    return DataManager(
      load: { _ in
        guard let data = initialData
        else {
          struct FileNotFound: Error {}
          throw FileNotFound()
        }
        return data
      },
      save: { data, url in
        struct SaveError: Error {}
        throw SaveError()
      }
    )
  }

  static let failToLoad = DataManager(
    load: { _ in
      struct LoadError: Error {}
      throw LoadError()
    },
    save: { newData, url in }
  )
}
