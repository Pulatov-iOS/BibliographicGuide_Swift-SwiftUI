//
//  TestMessageListViewModel.swift
//  BibliographicGuideTests
//
//  Created by Alexander on 20.05.23.
//

import XCTest

final class TestMessageListViewModel: XCTestCase {

    func testCountParticipants() {
        let messageListViewModel = MessageListViewModel()
        let actual = messageListViewModel.stringCountUsers(countUsers: 6)
        let expected = "6 участников"
        XCTAssertEqual(actual, expected)
    }
    
}
