import Foundation

public extension FileManager {
  enum FileManagerError: Error {
    case fileNotExisting
    case dataNotFound
    case decodeError
  }
  
  static func decode<T: Codable>(_ type: T.Type, from docName: String) throws -> T {
    if !FileManager().fileExists(atPath: Self.docDirURL.appendingPathComponent(docName).path) {
      throw FileManagerError.fileNotExisting
    }
    let url = Self.docDirURL.appendingPathComponent(docName)
    guard let data = try? Data(contentsOf: url) else {
      throw FileManagerError.dataNotFound
    }
    guard let loaded = try? JSONDecoder().decode(T.self, from: data) else {
      throw FileManagerError.decodeError
    }
    return loaded
  }
  
  static func endcodeAndSave<T: Codable>(objects: T, fileName: String) {
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(objects)
      let jsonString = String(decoding: data, as: UTF8.self)
      FileManager.saveDocument(contents: jsonString, docName: fileName)
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }
    
  private static func saveDocument(contents: String, docName: String) {
    let url = Self.docDirURL.appendingPathComponent(docName)
    do {
      
      try contents.write(to: url, atomically: true, encoding: .utf8)
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }
  
  private static var docDirURL: URL {
    Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
}
