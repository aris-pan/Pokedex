import SwiftUI

@MainActor
final class PokemonListViewModel: ObservableObject {
  @Published var pokemonList: [PokemonListModel.Pokemon] = []

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

  private var favouritesList: [PokemonListModel.Pokemon] = []
  private var allPokemonList: [PokemonListModel.Pokemon] = []

  let dependencies: Dependencies

  init(dependencies: Dependencies = .liveValues) {
    self.dependencies = dependencies
  }

  private func didSetFavourite() {
    pokemonList = (showFavourites ? favouritesList : allPokemonList)
  }

  func onAppear(
  ) {
    var favouritePokemonsSet: Set<PokemonListModel.Pokemon> = Set<PokemonListModel.Pokemon>()
    do {
      favouritePokemonsSet = try JSONDecoder().decode(
        Set<PokemonListModel.Pokemon>.self,
        from: dependencies.dataManager.load(URL.pokemonFileSystem)
      )
    } catch {
      print("\(error)")
    }

    favouritesList = Array(favouritePokemonsSet)
    didSetFavourite()

    // Run Get List only on first Appearance
    if allPokemonList.isEmpty {
      Task {
        do {
          let (data, urlResponse) = try await dependencies.apiClient.load(
            URLRequest(url: URL.pokemonNetwork)
          )

          guard let httpResponse = urlResponse as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw APIError.unexpectedResponse
          }

          allPokemonList = try JSONDecoder()
            .decode(PokemonListModel.self, from: data)
            .results
          pokemonList = allPokemonList
        } catch {
          print("\(error)")
        }
      }
    }
  }
}

fileprivate enum APIError: Error {
  case unexpectedResponse
}

extension URL {
  fileprivate static let pokemonFileSystem = Self.documentsDirectory.appending(component: "pokemons.json")
  fileprivate static let pokemonNetwork = URL(string: "https://pokeapi.co/api/v2/pokemon")!
}

struct ListView: View {
  @ObservedObject var model: PokemonListViewModel

  var body: some View {
    NavigationStack {
      List($model.pokemonList) { $pokemon in
        NavigationLink {
          PokemonDescriptionView(model: PokemonDetailsViewModel(
            dependencies: model.dependencies,
            pokemon: pokemon
          ))
        } label: {
          RowView(pokemon: $pokemon.wrappedValue)
        }
      }
      .navigationTitle("app_title_key")
      .navigationBarTitleDisplayMode(.inline)
      .listStyle(.insetGrouped)
      .searchable(text: $model.searchText, prompt: Text("search_key"))
      .animation(Animation.easeInOut, value: model.pokemonList)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Toggle("favourites_key", isOn: $model.showFavourites)
        }
      }
      .onAppear {
        model.onAppear()
      }
    }
  }
}

struct PokemonListView_Previews: PreviewProvider {
  static var previews: some View {
    ListView(model: PokemonListViewModel(
      dependencies: Dependencies.previewValues)
    )
  }
}
