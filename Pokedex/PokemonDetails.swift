import SwiftUI

fileprivate typealias Pokemon = PokemonListModel.Pokemon

@MainActor
final class PokemonDetailsViewModel: ObservableObject {
  @Published var isFavourite = false

  @Published var pokemonDetails: PokemonDetailsModel? = nil

  @Published var showAlert: Bool = false
  @Published var errorText = ""

  let pokemon: PokemonListModel.Pokemon

  let dependencies: Dependencies

  init(dependencies: Dependencies = .liveValues, pokemon: PokemonListModel.Pokemon) {
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

        pokemonDetails = try JSONDecoder().decode(PokemonDetailsModel.self, from: data)
      } catch {
        showAlert = true
        errorText = error.localizedDescription
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
    } catch {
      showAlert = true
      errorText = error.localizedDescription
    }
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

struct PokemonDetailsView: View {
  @ObservedObject var model: PokemonDetailsViewModel

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
          VStack {
            Text("moves_key")
            List(pokemonDetails.moves, id: \.self) { move in
              Text(move.replacingOccurrences(of: "-", with: " "))
            }
          }
          VStack {
            Text("types_key")
            List(pokemonDetails.types, id: \.self) { type in
              Label(type, systemImage: TypeDictionaries.symbolFor(type))
                .listItemTint(TypeDictionaries.colorFor(type))
            }
          }
        }
      }
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
    .alert(isPresented: $model.showAlert) {
      .init(title: Text(model.errorText))
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
  fileprivate static let pokemon = Pokemon(
    id: .init(rawValue: 1),
    name: "bulbasaur",
    image: ""
  )

  static var previews: some View {
    NavigationStack {
      PokemonDetailsView(model: PokemonDetailsViewModel(
        dependencies: Dependencies(
          dataManager: .mock(initialData: try? JSONEncoder().encode(PokemonListModel.mock.results)),
          apiClient: .mock(initialData: try? JSONEncoder().encode(PokemonDetailsModel.mock))
        ),
        pokemon: pokemon))
    }
  }
}
