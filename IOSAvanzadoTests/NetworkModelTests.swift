//
//  NetworkModelTests.swift
//  IOSAvanzadoTests
//
//  Created by Joaquín Corugedo Rodríguez on 20/9/22.
//

import XCTest
@testable import IOSAvanzado

enum ErrorMock: Error {
  case mockCase
}

final class NetworkModelTests: XCTestCase {
    
    private var urlSessionMock: URLSessionMock!
    private var sut: NetworkModel!

    override func setUpWithError() throws {
        urlSessionMock = URLSessionMock()
        sut = NetworkModel(urlSession: urlSessionMock)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testLoginFailWithNoData() {
      var error: NetworkError?
      
      //Given
      urlSessionMock.data = nil
      
      //When
      sut.login(user: "", password: "") { _, networkError in
        error = networkError
      }
      
      //Then
      XCTAssertEqual(error, .noData)
    }
    
    func testLoginFailWithError() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = nil
        urlSessionMock.error = ErrorMock.mockCase
        
        //When
        sut.login(user: "", password: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .other)
    }
    
    func testLoginFailWithErrorCodeNil() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = nil
        
        //When
        sut.login(user: "", password: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .errorCode(nil))
    }
    
    func testLoginFailWithErrorCode() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        //When
        sut.login(user: "", password: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .errorCode(404))
    }
    
    func testLoginSuccessWithMockToken() {
        var error: NetworkError?
        var retrievedToken: String?
        
        //Given
        urlSessionMock.error = nil
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.login(user: "", password: "") { token, networkError in
            retrievedToken = token
            error = networkError
        }
        
        //Then
        XCTAssertEqual(retrievedToken, "TokenString", "should have received a token")
        XCTAssertNil(error, "there should be no error")
    }
    
    func testGetHerosSuccess() {
        var error: NetworkError?
        var retrievedHeroes: [Hero]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getMockData(resourceName: "heroes")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getHeroes { heroes, networkError in
            error = networkError
            retrievedHeroes = heroes
        }
        
        //Then
        XCTAssertEqual(retrievedHeroes?.first?.id, "Hero ID", "should be the same hero as in the json file")
        XCTAssertNil(error, "there should be no error")
    }
    
    func testGetHerosSuccessWithNoHeroes() {
        var error: NetworkError?
        var retrievedHeroes: [Hero]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getMockData(resourceName: "noHeroes")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getHeroes { heroes, networkError in
            error = networkError
            retrievedHeroes = heroes
        }
        
        //Then
        XCTAssertNotNil(retrievedHeroes)
        XCTAssertEqual(retrievedHeroes?.count, 0)
        XCTAssertNil(error, "there should be no error")
    }
    
    func testGetLocationsSuccess(){
        var error: NetworkError?
        var retrievedLocations: [HeroCoordenates]?
        
        //Given
        sut.token = "TestToken"
        urlSessionMock.data = getMockData(resourceName: "locations")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getLocations(heroId: "Hero ID") { locations, networkError in
            error = networkError
            retrievedLocations = locations
        }
        
        //Then
        XCTAssertEqual(retrievedLocations?.first?.id, "Location ID", "should be the same location as in the json file")
        XCTAssertNil(error, "there should be no error")
    }

}

extension NetworkModelTests {
    func getMockData(resourceName: String) -> Data? {
        let bundle = Bundle(for: NetworkModelTests.self)
        
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
    
}
