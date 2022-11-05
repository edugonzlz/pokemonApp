import XCTest
import Combine
@testable import PokemonServices
@testable import CommonCore

class PokemonServiceTests: XCTestCase {

    var sut: PokemonService<PokemonCacheMock>!

    var apiClientMock: ApiClientMock!
    var pokemonCacheMock: PokemonCacheMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        apiClientMock = ApiClientMock()
        pokemonCacheMock = PokemonCacheMock()
        sut = PokemonService(apiClient: apiClientMock, cache: pokemonCacheMock)
        cancellables = []
    }

    //MARK: - Combine
    func testGetPokemonByIdWithCombine() throws {
        let expectation = XCTestExpectation()
        apiClientMock.resultValue = Pokemon.valid()

        sut.getPokemon(id: 0).sink { _ in
            expectation.fulfill()
        } receiveValue: { value in
            XCTAssertNotNil(value)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    func testGetPokemonByNameWithCombine() throws {
        let expectation = XCTestExpectation()
        apiClientMock.resultValue = Pokemon.valid()

        sut.getPokemon(name: "test").sink { _ in
            expectation.fulfill()
        } receiveValue: { value in
            XCTAssertNotNil(value)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    func testGetPokemonsWithCombine() throws {
        let expectation = XCTestExpectation()
        apiClientMock.resultValue = Pokemon.valid()

        sut.getPokemons(pagination: nil).sink { _ in
            expectation.fulfill()
        } receiveValue: { value in
            XCTAssertNotNil(value)
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
}

