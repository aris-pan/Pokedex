import Foundation

final class ContentLoader {
  enum Error: Swift.Error {
    case fileNotFound(name: String)
    case fileDecodingFailed(name: String, Swift.Error)
  }
  
  /// Get Data from Json from the Bundle where the ContentLoader resides.
  func loadBundledContent(fromFileNamed name: String) throws -> Data {
    guard let url = Bundle(for: Self.self).url(
      forResource: name,
      withExtension: "json"
    ) else {
      throw Error.fileNotFound(name: name)
    }
    
    do {
      return try Data(contentsOf: url)
    } catch {
      throw Error.fileDecodingFailed(name: name, error)
    }
  }
}
