import XCTest
@testable import Pokedex

@MainActor
final class PokemonListTests: XCTestCase {
  func testShowList() {
    let model = PokemonListViewModel(
      dependencies: Dependencies(
        dataManager: .mock(), apiClient: .mock(initialData: try? JSONEncoder().encode(PokemonListModel.mock))
      )
    )

    model.onAppear()
  }
}
