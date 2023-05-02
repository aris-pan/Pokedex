import SwiftUI

struct ImageErrorView: View {
  var body: some View {
    VStack {
      Image(systemName: "xmark.icloud")
      Text("error_key")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.secondary)
    .clipShape(Circle())
  }
}

struct ImageErrorView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      ImageErrorView()
        .frame(width: 60, height: 60)
      ImageErrorView()
        .frame(width: 200, height: 200)
      ImageErrorView()
        .frame(width: 100, height: 100)
    }
    .previewThatFits()
  }
}
