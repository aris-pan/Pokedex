import Foundation

public struct PokemonDetails: Codable, Equatable {
  public let height: Int
  public let weight: Int
  public let moves: [String]
  public let types: [String]
  
  public enum CodingKeys: CodingKey {
    case height
    case weight
    case moves
    case types
  }
  
  public init(
    height: Int,
    weight: Int,
    moves: [String],
    types: [String]
  ) {
    self.height = height
    self.weight = weight
    self.moves = moves
    self.types = types
  }
  
  // MARK: Codable
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: PokemonDetails.CodingKeys.self)
    
    height = try container.decode(Int.self, forKey: .height)
    weight = try container.decode(Int.self, forKey: .weight)

    let moves = try container.decode([Moves].self, forKey: .moves)
    let types = try container.decode([Types].self, forKey: .types)
    
    self.moves = moves.map { $0.move.name }
    self.types = types.map { $0.type.name }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: PokemonDetails.CodingKeys.self)

    try container.encode(self.height, forKey: PokemonDetails.CodingKeys.height)
    try container.encode(self.weight, forKey: PokemonDetails.CodingKeys.weight)
    
    let movesArray = moves.map { Moves(move: Moves.Move(name: $0)) }
    let typesArray = types.map { Types(type: Types.Species(name: $0)) }
    
    try container.encode(movesArray, forKey: PokemonDetails.CodingKeys.moves)
    try container.encode(typesArray, forKey: PokemonDetails.CodingKeys.types)
  }
  
  // MARK: Structs to Map to and from Backend Models
  public struct Moves: Codable {
    let move: Move
    
    public struct Move: Codable {
      let name: String
    }
  }
  
  public struct Types: Codable {
    let type: Species
    
    public struct Species: Codable {
      let name: String
    }
  }
}
