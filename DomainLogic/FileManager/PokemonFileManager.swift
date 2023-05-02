import SwiftUI

public protocol PokemonFileManager {
  func save(objects: Set<Pokemon>)
  func load() -> Set<Pokemon>
}

public class PokemonFileManagerLive: PokemonFileManager, ObservableObject {
  private let fileName = "pokemon.json"
  
  public func save(objects: Set<Pokemon>) {
    FileManager.endcodeAndSave(objects: objects, fileName: fileName)
    
    print("Live: Save files count is \(objects.count)")
  }
  
  public func load() -> Set<Pokemon> {
    let returnedSet = try? FileManager.decode(Set<Pokemon>.self, from: fileName)

    print("Live: Load files count is \(returnedSet?.count ?? 0)")
    return returnedSet ?? Set<Pokemon>()
  }
}

public class PokemonFileManagerPreview: PokemonFileManager, ObservableObject {
  private var objects: Set<Pokemon> = []
  
  public init() {}
  
  public func save(objects: Set<Pokemon>) {
    self.objects = objects
    print("Preview: Fake Save to Documents Directory")
  }
  
  public func load() -> Set<Pokemon> {
    print("Preview: Check \(objects.count), \(objects.first?.name ?? "")")
    return objects
  }
}
