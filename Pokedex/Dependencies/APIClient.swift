import Foundation

struct APIClient {
  var load: (URLRequest) async throws -> (Data, URLResponse)
}

extension APIClient {
  static let liveValue = APIClient(
    load: URLSession.shared.data
  )
}

extension APIClient {
  private static var data: Data?

  static func mock(initialData: Data? = nil) -> APIClient {
    self.data = initialData
    return APIClient(
      load: { _ in
        guard let data = self.data
        else {
          struct ResourceNotFound: Error {}
          throw ResourceNotFound()
        }
        return (data, URLResponse())
      }
    )
  }
}
