import SwiftUI
import DomainLogic

struct DetailsView: View {
  @Environment(\.pokemonAPI) var pokemonAPI: API.Pokemon
  @Environment(\.fileManager) var fileManager: PokemonFileManager
  let pokemon: Pokemon
  
  @StateObject var viewModel = DetailsViewModel()
  
  var body: some View {
    VStack {
      HStack {
        CacheAsyncImageWrapper(url: pokemon.image)
          .frame(maxWidth: .infinity, maxHeight: 100)
          .padding()
        
        VStack(alignment: .leading) {
          if let pokemonDetails = viewModel.pokemonDetails {
            Text("height_key") + Text("\(pokemonDetails.height)")
            Text("weight_key") + Text("\(pokemonDetails.weight)")
          } else {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .red))
          }
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity)
      }
      
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(TypeDictionaries.colorFor(
            viewModel.pokemonDetails?.types.first ?? ""
          ))
          .frame(maxHeight: .infinity)
      )
      .padding()
      .shadow(radius: 10)
      HStack {
        if let pokemonDetails = viewModel.pokemonDetails {
          CaptuleListView(title: "moves_key", items: pokemonDetails.moves) { move in
            Text(FormatString.removeDash(move))
          }
          CaptuleListView(title: "types_key", items: pokemonDetails.types) { type in
            Label(type, systemImage: TypeDictionaries.symbolFor(type))
          }
        }
      }
      .listStyle(.plain)
      Spacer()
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .principal) {
        HStack {
          Text(pokemon.name.capitalized).font(.headline)
          Text("#\(pokemon.id)").fontWeight(.light).italic()
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        HStack(spacing: 0) {
          favouriteButton
        }
      }
    }
    .onAppear {
      viewModel.onAppear(
        pokemonFileManager: fileManager,
        pokemonAPI: pokemonAPI,
        pokemon: pokemon
      )
    }
  }
  
  private var favouriteButton: some View {
    Button {
      viewModel.onAddOrRemoveFavourite()
    } label: {
      Label("favorite", systemImage: viewModel.isFavourite ? "star.fill" : "star")
    }
  }
}

struct PokemonDetailsView_Previews: PreviewProvider {
  static let pokemon = Pokemon(id: 1, name: "bulbasaur", image: "")
  static let pokemonDetails = PokemonDetails(
    height: 54, weight: 455,
    moves: [
      "bite-whip", "fireball-edge", "fly", "cut",
      "bite-slam", "fireball-drain", "fly-seed", "cut-whip",
      "bite2", "fireball2", "fly2", "cut2", "bite3",
      "fireball3", "fly3","cut3"
    ],
    types: ["grass", "poison"])
  
  static var previews: some View {
    NavigationStack {
      DetailsView(pokemon: pokemon)
        .environment(\.pokemonAPI, .preview(objects: pokemonDetails))
        .environment(\.fileManager, PokemonFileManagerPreview())
    }
  }
}
