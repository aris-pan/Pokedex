import Foundation

public struct Pokemon: Codable, Hashable, Identifiable {
  
  public struct Id: Codable, Hashable, RawRepresentable {
    public var rawValue: Int
    public init(rawValue: Int) {
      self.rawValue = rawValue
    }
  }
  
  public var id: Id
  public let name: String
  public let image: URL?
  
  enum CodingKeys: String, CodingKey {
    case name
    case url
  }
  
  public init(id: Id, name: String, image: String) {
    self.id = id
    self.name = name
    self.image = URL(string: image)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    let url = try container.decodeIfPresent(String.self, forKey: .url)
    
    guard let pokemonID = url?.components(separatedBy: "/")[safe: 6],
          let intID = Int(pokemonID) else {
      throw API.Errors.unexpectedResponse
    }
    
    self.id = Id(rawValue: intID)
    self.image = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonID).png")
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode("https://pokeapi.co/api/v2/pokemon/\(id)", forKey: .url)
  }
}
