import Foundation

public extension API {
  struct Pokemon {
    static let endpoint = "https://pokeapi.co/api/v2/pokemon"
    
    // MARK: -- Inject the closure to use to retrieve the data for URLRequest
    let urlSessionDataAdapter: API.URLSessionDataAdapter

    public static func live() -> Self {
      Self(urlSessionDataAdapter: URLSession.shared.data)
    }
    
    public static func test(data: Data, response: URLResponse) -> Self {
      Self(urlSessionDataAdapter: { _ in (data, response) })
    }
    
    public static func preview<T>(objects: T) -> Self where T: Encodable {
      
      guard let data = try? JSONEncoder().encode(objects),
            let response = HTTPURLResponse(
        url: URL(string: "https://www.google.com/")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      ) else {
        fatalError("Could not encode data for preview.")
      }
      
      return Self(urlSessionDataAdapter: { _ in (data, response) })
    }
    
    /// Generic query for any kind of decodable json
    func get<T: Decodable>(url: URL) async throws -> T {

      let urlRequest = URLRequest(url: url)
      
      let (data, urlResponse) = try await urlSessionDataAdapter(urlRequest)
      
      guard let httpResponse = urlResponse as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
        throw API.Errors.unexpectedResponse
      }
      
      let response = try JSONDecoder().decode(T.self, from: data)
      
      return response
    }
  }
}
