import XCTest
import Combine
@testable import PokemonServices
@testable import CommonCore

class ApiClientTests: XCTestCase {

    var sut: PokemonService<PokemonCacheMock>!
    var apiClientMock: ApiClientMock!
    var pokemonCacheMock: PokemonCacheMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        apiClientMock = ApiClientMock()
        pokemonCacheMock = PokemonCacheMock()
        sut = PokemonService(apiClient: apiClientMock, pokemonCache: pokemonCacheMock)
        cancellables = []
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testGetPokemonById() throws {
        let expectation = XCTestExpectation()
        apiClientMock.resultValue = Pokemon.valid()

        sut.getPokemon(id: 0) { result in
            XCTAssertNotNil(try? result.get())
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testGetPokemonByName() throws {
        let expectation = XCTestExpectation()
        apiClientMock.resultValue = Pokemon.valid()

        sut.getPokemon(name: "test") { result in
            XCTAssertNotNil(try? result.get())
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testGetPokemonList() throws {
        let expectation = XCTestExpectation()
        apiClientMock.resultValue = PokemonList.valid()

        sut.getPokemons(pagination: nil) { result in
            XCTAssertNotNil(try? result.get())
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testGetPokemonInsertValueInCache() {
        let expectation = XCTestExpectation()
        apiClientMock.resultValue = Pokemon.valid()

        sut.getPokemon(name: "test") { result in
            XCTAssertNotNil(try? result.get())
            XCTAssertTrue(self.pokemonCacheMock.insertValueCalled)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testGetPokemonGetValueFromCache() {
        let expectation = XCTestExpectation()
        apiClientMock.resultValue = Pokemon.valid()
        pokemonCacheMock.valueForKeyValue = Pokemon.valid()
        
        sut.getPokemon(name: "test") { result in
            XCTAssertNotNil(try? result.get())
            XCTAssertTrue(self.pokemonCacheMock.valueForKeyCalled)
            XCTAssertNotNil(self.pokemonCacheMock.valueForKeyValue)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
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

