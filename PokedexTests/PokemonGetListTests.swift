import XCTest
@testable import Pokedex

final class PokemonGetListTests: XCTestCase {
  func testGetListReturnsFailureWhenAPIFails() async throws {
    Current.apiClient.load = { _ in throw Errors.someFailure }

//    let apiFailure: API.URLSessionDataAdapter = { _ in throw Errors.someFailure }

//    Current.apiClient.load
//    let getList = API.Pokemon(urlSessionDataAdapter: apiFailure)
//    await XCTAssertThrowsError(try await getList.getList())
  }
  
  func testGetListReturnsValuesOnAPISuccess() async throws {
//    let responseData = try ContentLoader().loadBundledContent(fromFileNamed: "sampleResponsePokemonList")
//    let expectedURL = try XCTUnwrap(URL(string: API.Pokemon.endpoint))
//    let httpResponse = try XCTUnwrap(HTTPURLResponse(url: expectedURL, statusCode: 200, httpVersion: "1.2", headerFields: nil))
//
//    let pokemonAPI = API.Pokemon.test(data: responseData, response: httpResponse)
//    
//    let receivedPokemonList = try await pokemonAPI.getList()
//    XCTAssertEqual(receivedPokemonList, SampleAssertionData.pokemonList)
  }
}
