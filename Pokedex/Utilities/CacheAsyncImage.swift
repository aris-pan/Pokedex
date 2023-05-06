import SwiftUI

struct CacheAsyncImageWrapper: View {
  let url: URL?
  var body: some View {
    
    CacheAsyncImage(
      url: url) { phase in
        switch phase {
        case .success(let image):
          image
            .resizable()
            .aspectRatio(1, contentMode: .fit)
        case .empty:
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .red))
        default:
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .red))
        }
      }
  }
}

struct CacheAsyncImage<Content: View>: View {
  private let url: URL?
  private let scale: CGFloat
  private let transaction: Transaction
  private let content: (AsyncImagePhase) -> Content
  
  init(
    url: URL?,
    scale: CGFloat = 1.0,
    transaction: Transaction = Transaction(),
    @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
      
      self.url = url
      self.scale = scale
      self.transaction = transaction
      self.content = content
    }
  
  var body: some View {
    if let cached = ImageCache[url] {
      content(.success(cached))
    } else {
      AsyncImage(
        url: url,
        scale: scale,
        transaction: transaction
      ) { phase in
        cacheAndReturnView(phase)
      }
    }
  }
  
  private func cacheAndReturnView(_ phase: AsyncImagePhase) -> some View {
    if case .success(let image) = phase {
      ImageCache[url] = image
    }
    
    return content(phase)
  }
}

fileprivate final class ImageCache {
  private static var cache: [URL: Image] = [:]
  
  static subscript(url: URL?) -> Image? {
    get {
      guard let url else { return nil }
      return ImageCache.cache[url]
    }
    set {
      guard let url else { return }
      ImageCache.cache[url] = newValue
    }
  }
}
