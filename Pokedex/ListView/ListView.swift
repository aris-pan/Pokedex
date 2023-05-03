import SwiftUI
import DomainLogic

struct ListView: View {
  @Environment(\.pokemonAPI) var pokemonAPI: API.Pokemon
  @Environment(\.fileManager) var fileManager: PokemonFileManager

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
      .onAppear {
        viewModel.onAppear(
          pokemonFileManager: fileManager,
          pokemonAPI: pokemonAPI
        )
      }
    }
  }
}

struct PokemonListView_Previews: PreviewProvider {
  static var previewObjects = API.Pokemon.PagedResponse(results: [
    Pokemon(
      id: Pokemon.Id(rawValue: 11),
      name: "Hello",
      image: ""
    ),
    Pokemon(
      id: Pokemon.Id(rawValue: 42),
      name: "Hello2",
      image: ""
    ),
    Pokemon(
      id: Pokemon.Id(rawValue: 43),
      name: "Hello1",
      image: ""
    )
  ])
  
  static var previews: some View {
    ListView()
    // TODO: we need to somehow pass both api calls here,
    // not only the get List.
      .environment(\.pokemonAPI, .preview(objects: previewObjects))
      .environment(\.fileManager, .preview)
  }
}
