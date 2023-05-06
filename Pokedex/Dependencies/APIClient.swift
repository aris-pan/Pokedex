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
  static func mock(initialData: Data?) -> APIClient {
    return APIClient(
      load: { _ in
        guard let initialData else {
          struct DataNotFound: Error {}
          throw DataNotFound()
        }
        return (initialData, HTTPURLResponse(url: URL.init(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
      }
    )
  }
}
