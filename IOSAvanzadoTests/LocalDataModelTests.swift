//
//  LocalDataModelTests.swift
//  DragonBallXibsTests
//
//  Created by Joaquín Corugedo Rodríguez on 21/7/22.
//

import XCTest
@testable import IOSAvanzado

class LocalDataModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        LocalDataModel.deleteToken()
        LocalDataModel.deleteDate()
    }

    func testSaveToken() throws {
      //Given
      let storedToken = "TestToken"
      //When
      LocalDataModel.save(token: storedToken)
      //Then
      let retrievedToken = LocalDataModel.getToken()
      XCTAssertEqual(retrievedToken, storedToken, "retrieved token doesn't match stored token")
    }

    func testGetTokenWhenNoTokenSaved() throws {
      //Then
      let retrievedToken = LocalDataModel.getToken()
      XCTAssertNil(retrievedToken, "There should be no saved token")
    }
    
    func testDeleteToken() throws {
      //Given
      let storedToken = "TestToken"
      LocalDataModel.save(token: storedToken)
      //When
      LocalDataModel.deleteToken()
      //Then
      let retrievedToken = LocalDataModel.getToken()
      XCTAssertNil(retrievedToken, "There should be no saved token")
    }
    
    func testSaveSyncDate(){
        //Given
        let storedDate = Date()
        //When
        LocalDataModel.saveSyncDate(date: storedDate)
        //Then
        let retrievedDate = LocalDataModel.getSyncDate()
        XCTAssertEqual(retrievedDate, storedDate , "retrieved date doesn't match stored date")
    }
    
    func testGetDateWhenNoDateSaved() throws {
      //Then
      let retrievedDate = LocalDataModel.getSyncDate()
      XCTAssertNil(retrievedDate, "There should be no saved date")
    }
}
