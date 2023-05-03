import Foundation

public extension API.Pokemon {
  func getDetails(id: Pokemon.Id) async throws -> PokemonDetails {
    guard let url = URL(string: Self.endpoint + "/\(id.rawValue)") else {
      throw API.Errors.invalidUrl
    }
    
    return try await get(url: url)
  }
}
