import SwiftUI
import DomainLogic

@MainActor
final class DetailsViewModel: ObservableObject {
  @Published var isFavourite = false
  @Published var pokemonDetails: PokemonDetails? = nil

  // Dependencies
  private var pokemonFileManager: PokemonFileManager?
  private var pokemonAPI: API.Pokemon?
  private var pokemon: Pokemon? = nil
  
  func onAppear(pokemonFileManager: PokemonFileManager, pokemonAPI: API.Pokemon, pokemon: Pokemon) {
    self.pokemonFileManager = pokemonFileManager
    self.pokemonAPI = pokemonAPI
    self.pokemon = pokemon
    
    checkIsFavourite()
    
    Task {
      do {
        pokemonDetails = try await pokemonAPI.getDetails(id: pokemon.id)
      } catch {
        print("\(error)")
      }
    }
  }
  
  func onAddOrRemoveFavourite() {
    guard var favouritePokemons = pokemonFileManager?.load(),
          let pokemon = pokemon else {
      print("Could not get pokemons")
      return
    }
    
    if isFavourite {
      favouritePokemons.remove(pokemon)
    } else {
      favouritePokemons.insert(pokemon)
    }
    pokemonFileManager?.save(objects: favouritePokemons)
    
    checkIsFavourite()
  }
  
  private func checkIsFavourite() {
    isFavourite = pokemonFileManager?.load()
      .contains(where: { $0.id == self.pokemon!.id }) ?? false
  }
}

