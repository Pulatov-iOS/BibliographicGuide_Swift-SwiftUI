//
//  testPasswordComplexity.swift
//  BibliographicGuideTests
//
//  Created by Alexander on 20.05.23.
//

import XCTest

final class TestRegistrationViewModel: XCTestCase {
    
    func testPasswordComplexity() {
        let registrationViewModel = RegistrationViewModel()
        let actual: () = registrationViewModel.checkPassword(password: "dhHk43")
        let expected = true
        XCTAssertEqual(registrationViewModel.statusCheckPassword[0], expected)
        XCTAssertEqual(registrationViewModel.statusCheckPassword[1], expected)
        XCTAssertEqual(registrationViewModel.statusCheckPassword[2], expected)
    }
    
    func testEmailComplexity() {
        let registrationViewModel = RegistrationViewModel()
        let actual: () = registrationViewModel.checkEmail(email: "pulatov@mail.ru")
        let expected = true
        XCTAssertEqual(registrationViewModel.statusCheckEmail, expected)
    }

}
