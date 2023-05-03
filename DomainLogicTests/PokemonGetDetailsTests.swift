import XCTest
@testable import DomainLogic

final class PokemonGetDetailsTests: XCTestCase {
  func testGetDetailsReturnsFailureWhenAPIFails() async throws {
    let apiFailure: API.URLSessionDataAdapter = { _ in throw Errors.someFailure }
    let getList = API.Pokemon(urlSessionDataAdapter: apiFailure)
    await XCTAssertThrowsError(try await getList.getDetails(id: Pokemon.Id(rawValue: 6)))
  }
  
  func testGetDetailsReturnsValuesOnAPISuccess() async throws {
    let responseData = try ContentLoader().loadBundledContent(fromFileNamed: "sampleResponsePokemonDetails")
    let expectedURL = try XCTUnwrap(URL(string: API.Pokemon.endpoint + "/\(6)"))
    let httpResponse = try XCTUnwrap(HTTPURLResponse(url: expectedURL, statusCode: 200, httpVersion: "1.2", headerFields: nil))

    let pokemonAPI = API.Pokemon.test(data: responseData, response: httpResponse)

    let receivedPokemonDetails = try await pokemonAPI.getDetails(id: Pokemon.Id(rawValue: 6))
    XCTAssertEqual(receivedPokemonDetails, SampleAssertionData.pokemonDetails)
  }
}
