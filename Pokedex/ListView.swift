import SwiftUI

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

  private var favouritesList: [Pokemon] = []
  private var allPokemonList: [Pokemon] = []

  private func didSetFavourite() {
    pokemonList = (showFavourites ? favouritesList : allPokemonList)
  }

  func onAppear(
  ) {
    var favouritePokemonsSet: Set<Pokemon> = Set<Pokemon>()
    do {
      favouritePokemonsSet = try JSONDecoder().decode(
        Set<Pokemon>.self,
        from: Current.dataManager.load(URL.pokemonFileSystem)
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
          let (data, urlResponse) = try await Current.apiClient.load(
            URLRequest(url: URL.pokemonNetwork)
          )

          guard let httpResponse = urlResponse as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw APIError.unexpectedResponse
          }

          allPokemonList = try JSONDecoder()
            .decode(Pokemon.PagedResponse.self, from: data)
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
  @StateObject var viewModel = ListViewModel()

  var body: some View {
    NavigationStack {
      List($viewModel.pokemonList) { $pokemon in
        NavigationLink {
          DetailsView(pokemon: pokemon)
        } label: {
          RowView(pokemon: $pokemon.wrappedValue)
        }
      }
      .navigationTitle("app_title_key")
      .navigationBarTitleDisplayMode(.inline)
      .listStyle(.insetGrouped)
      .searchable(text: $viewModel.searchText, prompt: Text("search_key"))
      .animation(Animation.easeInOut, value: viewModel.pokemonList)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Toggle("favourites_key", isOn: $viewModel.showFavourites)
        }
      }
    }
    .onAppear(perform: viewModel.onAppear)
  }
}

struct PokemonListView_Previews: PreviewProvider {
  static var previews: some View {
    ListView()
  }
}
