import Foundation

/// API namespace & common errors
public struct API {
  typealias URLSessionDataAdapter = (URLRequest) async throws -> (Data, URLResponse)
  
  public enum Errors: Error {
    case invalidUrl
    case unexpectedResponse
  }
}
