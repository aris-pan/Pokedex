import Foundation

extension API.Pokemon {
  struct PagedResponse: Codable {
    let count: Int?
    let next: URL?
    let previous: URL?
    let results: [Pokemon]
    
    init(results: [Pokemon]) {
      self.count = nil
      self.next = nil
      self.previous = nil
      self.results = results
    }
  }
  
  func getList() async throws -> [Pokemon] {
    guard let url = URL(string: Self.endpoint) else {
      throw API.Errors.invalidUrl
    }
    
    let pagedResponse: PagedResponse = try await get(url: url)
    return pagedResponse.results
  }
}
