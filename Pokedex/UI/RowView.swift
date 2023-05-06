import SwiftUI

struct RowView: View {
  let pokemon: PokemonListModel.Pokemon
  let imageUrl: URL?

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      CacheAsyncImageWrapper(url: imageUrl)
        .frame(width: 60, height: 60)
      VStack(alignment: .leading) {
        Text("#\(pokemon.id.rawValue)")
          .fontWeight(.light)
          .italic()
        Text(pokemon.name.capitalized)
          .fontWeight(.heavy)
      }
    }
    .padding()
  }
}

struct ItemView_Previews: PreviewProvider {
  static let pokemon = PokemonListModel.Pokemon(
    id: 3,
    name: "charmander",
    url: ""
  )
  
  static var previews: some View {
    RowView(pokemon: pokemon, imageUrl: nil)
      .previewLayout(.sizeThatFits)
  }
}
