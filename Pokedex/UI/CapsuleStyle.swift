import SwiftUI

struct CaptuleStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding(8)
      .listRowSeparator(.hidden)
      .background(
        Capsule()
          .fill(Color(UIColor.systemBackground))
          .shadow(radius: 10, x: 5, y: 5)
      )
  }
}

extension View {
  var captuleStyle: some View {
    modifier(CaptuleStyle())
  }
}
