//
//  TestCreateRecordViewModel.swift
//  BibliographicGuideTests
//
//  Created by Alexander on 20.05.23.
//

import XCTest

final class TestCreateRecordViewModel: XCTestCase {

    func testCheckYear() {
        let createRecordViewModel = CreateRecordViewModel()
        let actual = createRecordViewModel
        let expected = "6 участников"
        XCTAssertEqual(actual, expected)
    }

}
