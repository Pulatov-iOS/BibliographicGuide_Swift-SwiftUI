//
//  TestRecordListViewModel.swift
//  BibliographicGuideTests
//
//  Created by Alexander on 20.05.23.
//

import XCTest

final class TestRecordListViewModel: XCTestCase {

    func testCheckEditingTime() {
        let recordListViewModel = RecordListViewModel()
        let record = Record(idUser: "", dateChange: Date(), title: "", year: 2010, idKeywords: [], authors: "", linkDoi: "", linkWebsite: "", journalName: "", journalNumber: "", pageNumbers: "", description: "", idUsersReporting: [], universityRecord: false)
        let actual = recordListViewModel.checkingEditingTime(record, withDescription: true)
        let expected = "0 сек. назад"
        XCTAssertEqual(actual, expected)
    }
    
}
