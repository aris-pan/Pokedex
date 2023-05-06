import SwiftUI
import UIKit

struct TypeDictionaries {
  
  static func colorFor(_ type: String) -> Color {
    Color(uiColor: typeToColor[type] ?? .black)
  }
  
  static func symbolFor(_ type: String) -> String {
    typeToSymbol[type] ?? "pawprint.fill"
  }
  
  private static let typeToSymbol: [String: String] = [
    "normal": "pawprint.fill",
    "fighting": "figure.martial.arts",
    "flying": "bird.fill",
    "poison": "syringe.fill",
    "ground": "mountain.2.fill",
    "rock": "mountain.2.fill",
    "bug": "ant.fill",
    "ghost": "moon.fill",
    "steel": "mountain.2.fill",
    "fire": "flame.fill",
    "water": "drop.fill",
    "grass": "leaf.fill",
    "electric": "bolt.fill",
    "psychic": "moon.fill",
    "ice": "snowflake",
    "dragon": "bird.fill",
    "dark": "moon.fill",
    "fairy": "bird.fill",
    "unknown": "mug.fill",
    "shadow": "moon.fill"
  ]
  
  private static let typeToColor: [String: UIColor] = [
    "normal": #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
    "fighting": #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
    "flying": #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
    "poison": #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1),
    "ground": #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1),
    "rock": #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
    "bug": #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1),
    "ghost": #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
    "steel": #colorLiteral(red: 0.6891952404, green: 0.7373502986, blue: 0.7159980659, alpha: 1),
    "fire": #colorLiteral(red: 0.8484928675, green: 0.2655537516, blue: 0.1604157893, alpha: 1),
    "water": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
    "grass": #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),
    "electric": #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
    "psychic": #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1),
    "ice": #colorLiteral(red: 0, green: 0.6603779807, blue: 0.9376966259, alpha: 1),
    "dragon": #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1),
    "dark": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
    "fairy": #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
    "unknown": #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
    "shadow": #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
  ]
  
}
