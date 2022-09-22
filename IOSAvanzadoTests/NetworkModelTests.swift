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

}
