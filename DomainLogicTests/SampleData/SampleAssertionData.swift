import Foundation
@testable import DomainLogic

struct SampleAssertionData {
  static let pokemonDetails: PokemonDetails = PokemonDetails(
    height: 3,
    weight: 32,
    moves: [
      "poison-sting",
      "string-shot",
      "bug-bite",
      "electroweb"
    ],
    types: [
      "bug",
      "poison"
    ]
  )
  
  static let pokemonList: [Pokemon] = [
    .init(
      id: 1,
      name: "bulbasaur",
      image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
    ),
    .init(
      id: 2,
      name: "ivysaur",
      image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png"
    ),
    .init(
      id: 3,
      name: "venusaur",
      image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png"
    ),
    .init(
      id: 4,
      name: "charmander",
      image: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png"
    )
  ]
}
