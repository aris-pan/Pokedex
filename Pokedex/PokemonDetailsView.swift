import SwiftUI

@MainActor
final class PokemonDetailsModel: ObservableObject {
  @Published var isFavourite = false

  @Published var pokemonDetails: PokemonDetails? = nil

  let pokemon: Pokemon

  let dependencies: Dependencies

  init(dependencies: Dependencies = .liveValues, pokemon: Pokemon) {
    self.dependencies = dependencies
    self.pokemon = pokemon
  }

  func onAppear() {

    isFavourite = getFavourites()
      .contains(where: { $0.id == pokemon.id })

    Task {
      do {
        let (data, urlResponse) = try await dependencies.apiClient.load(
          URLRequest(url: URL.pokemonNetwork.appending(path: "/\(pokemon.id.rawValue)"))
        )

        guard let httpResponse = urlResponse as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw APIError.unexpectedResponse
        }

        pokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: data)
      } catch {
        print("\(error)")
      }
    }
  }

  func onAddOrRemoveFavourite() {
    var favouritePokemonsSet = getFavourites()

    if isFavourite {
      favouritePokemonsSet.remove(pokemon)
    } else {
      favouritePokemonsSet.insert(pokemon)
    }

    do {
      try dependencies.dataManager.save(
        JSONEncoder().encode(favouritePokemonsSet),
        URL.pokemons
      )

      isFavourite.toggle()
    } catch { }
  }

  private func getFavourites() -> Set<Pokemon> {
    var favouritePokemonsSet: Set<Pokemon> = Set<Pokemon>()
    do {
      favouritePokemonsSet = try JSONDecoder().decode(
        Set<Pokemon>.self,
        from: dependencies.dataManager.load(URL.pokemons)
      )
    } catch {

    }
    return favouritePokemonsSet
  }
}

fileprivate enum APIError: Error {
  case unexpectedResponse
}

extension URL {
  fileprivate static let pokemons = Self.documentsDirectory.appending(component: "pokemons.json")
  fileprivate static let pokemonNetwork = URL(string: "https://pokeapi.co/api/v2/pokemon")!
}

struct DetailsView: View {
  @ObservedObject var model: PokemonDetailsModel

  var body: some View {
    VStack {
      HStack {
        CacheAsyncImageWrapper(url: model.pokemon.image)
          .frame(maxWidth: .infinity, maxHeight: 100)
          .padding()
        
        VStack(alignment: .leading) {
          if let pokemonDetails = model.pokemonDetails {
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
            model.pokemonDetails?.types.first ?? ""
          ))
          .frame(maxHeight: .infinity)
      )
      .padding()
      .shadow(radius: 10)
      HStack {
        if let pokemonDetails = model.pokemonDetails {
          CaptuleListView(title: "moves_key", items: pokemonDetails.moves) { move in
            Text(move.replacingOccurrences(of: "-", with: " "))
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
          Text(model.pokemon.name.capitalized).font(.headline)
          Text("#\(model.pokemon.id.rawValue)").fontWeight(.light).italic()
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        HStack(spacing: 0) {
          favouriteButton
        }
      }
    }
    .onAppear {
      model.onAppear()
    }
  }
  
  private var favouriteButton: some View {
    Button {
      model.onAddOrRemoveFavourite()
    } label: {
      Label("favorite", systemImage: model.isFavourite ? "star.fill" : "star")
    }
  }
}

struct PokemonDetailsView_Previews: PreviewProvider {
  static let pokemon = Pokemon(
    id: .init(rawValue: 1),
    name: "bulbasaur",
    image: "")
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
      DetailsView(model: PokemonDetailsModel(
        dependencies: .previewValues,
        pokemon: pokemon
      ))
    }
  }
}
