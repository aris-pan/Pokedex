import SwiftUI
import DomainLogic

@MainActor
final class ListViewModel: ObservableObject {
  @Published var pokemonList: [Pokemon] = []
  @Published var showFavourites = false {
    didSet {
      pokemonList = (showFavourites ? favouritesList : allPokemonList)
    }
  }
  
  @Published var searchText = "" {
    didSet {
      pokemonList = pokemonList.filter { $0.name.hasPrefix(searchText.lowercased()) }
    }
  }
  
  // Dependencies
  private var pokemonAPI: API.Pokemon?
  
  private var favouritesList: [Pokemon] = []
  private var allPokemonList: [Pokemon] = []
  
  func onAppear(
    pokemonFileManager: PokemonFileManager,
    pokemonAPI: API.Pokemon
  ) {
    self.pokemonAPI = pokemonAPI
    
    let pokemonSet = pokemonFileManager.load()
    favouritesList = Array(pokemonSet)
    
    // TODO: Remove below copy paste
    pokemonList = (showFavourites ? favouritesList : allPokemonList)
    
    // Run Get List only on first Appearance
    if allPokemonList.isEmpty {
      Task {
        do {
          allPokemonList = try await pokemonAPI.getList()
          // Initialize list with all pokemon from api.
          pokemonList = allPokemonList
        } catch {
          print("\(error)")
        }
      }
    }
  }
}
