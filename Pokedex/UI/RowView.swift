import SwiftUI

struct RowView: View {
  let pokemon: Pokemon
  
  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      CacheAsyncImageWrapper(url: pokemon.image)
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
  static let pokemon = Pokemon(
    id: 3,
    name: "charmander",
    image: "")
  
  static var previews: some View {
    RowView(pokemon: pokemon)
      .previewLayout(.sizeThatFits)
  }
}
