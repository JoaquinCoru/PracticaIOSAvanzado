//
//  LoginViewModelTest.swift
//  IOSAvanzadoTests
//
//  Created by Joaquín Corugedo Rodríguez on 19/9/22.
//

import XCTest
@testable import IOSAvanzado

final class LoginViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ViewModel_CallLoginService_TokenSuccess() {
        let network = NetWorkModelSpy()
        let viewModel = LoginViewModel(networkModel: network)

        viewModel.login(with: "Joaquin", password: "") { token, error in
            XCTAssertEqual(token, "miToken")
        }
    }
    
    func test_ViewModel_CallLoginService_TokenFailure(){
        let network = NetWorkModelSpy()
        let viewModel = LoginViewModel(networkModel: network)
        
        viewModel.login(with: "Paco", password: "") {token, error in
            XCTAssertNotNil(error, "There should be an error")
            XCTAssertNil(token,"Token should be nil" )
        }
        
    }


}
