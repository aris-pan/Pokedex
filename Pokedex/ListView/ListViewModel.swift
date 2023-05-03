import SwiftUI
import DomainLogic

@MainActor
final class ListViewModel: ObservableObject {
  @Published var pokemonList: [Pokemon] = []
  @Published var showFavourites = false {
    didSet {
      didSetFavourite()
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
  
  private func didSetFavourite() {
    pokemonList = (showFavourites ? favouritesList : allPokemonList)
  }
  
  func onAppear(
    pokemonFileManager: PokemonFileManager,
    pokemonAPI: API.Pokemon
  ) {
    self.pokemonAPI = pokemonAPI
    
    let pokemonSet = pokemonFileManager.load()
    favouritesList = Array(pokemonSet)
    
    didSetFavourite()
    
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
