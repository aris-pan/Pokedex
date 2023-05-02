import SwiftUI

struct CaptuleListView<Content: View>: View {
  var title: LocalizedStringKey
  var items: [String]
  var content: (String) -> Content
  
  var body: some View {
    VStack {
      Text(title).font(.subheadline)
      List(items, id: \.self) { type in
        HStack {
          Spacer()
          content(type)
            .captuleStyle
          Spacer()
        }
        .listItemTint(TypeDictionaries.colorFor(type))
        .listRowSeparator(.hidden)
      }
    }
  }
}


struct CaptuleListView_Previews: PreviewProvider {
  static var previews: some View {
    CaptuleListView(
      title: "list title",
      items: ["first", "second", "third", "fourth"]
    ) { item in
      Text(item)
    }
  }
}
