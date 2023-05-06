import Foundation

fileprivate enum APIError: Error {
  case unexpectedResponse
}

struct PokemonListModel: Codable {
  let results: [Pokemon]

  struct Pokemon: Codable, Hashable, Identifiable {
    typealias Id = Tagged<Pokemon, Int>

    let id: Id
    let name: String
    let url: String

    init(id: ID, name: String, url: String) {
      self.id = id
      self.name = name
      self.url = url
    }

    enum CodingKeys: String, CodingKey {
      case name
      case url
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decode(String.self, forKey: .name)
      self.url = try container.decode(String.self, forKey: .url)

      guard let pokemonID = url.components(separatedBy: "/")[safe: 6],
            let intID = Int(pokemonID) else {
        throw APIError.unexpectedResponse
      }

      self.id = Id(rawValue: intID)
    }
  }
}

extension PokemonListModel {
  static let mock = Self.init(results: [
    .init(id: 1, name: "Pikatsu", url: ""),
    .init(id: 2, name: "Pikatsu New", url: ""),
    .init(id: 3, name: "Pikatsu Junior", url: ""),
    .init(id: 4, name: "Pikatsu Senior", url: ""),
  ])
}
