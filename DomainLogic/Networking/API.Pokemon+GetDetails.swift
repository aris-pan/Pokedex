import Foundation

public extension API.Pokemon {
  func getDetails(id: Int) async throws -> PokemonDetails {
    
    guard let url = URL(string: Self.endpoint + "/\(id)") else {
      throw API.Errors.invalidUrl
    }
    
    return try await get(url: url)
  }
}
