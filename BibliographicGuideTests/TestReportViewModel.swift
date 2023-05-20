//
//  TestReportViewModel.swift
//  BibliographicGuideTests
//
//  Created by Alexander on 20.05.23.
//

import XCTest

final class TestReportViewModel: XCTestCase {

    func testCkeckYear() {
        let reportViewModel = ReportViewModel()
        let actual = reportViewModel.checkingYear(yearFromInReport: "2010", yearBeforeInReport: "2015")
        let expected = true
        XCTAssertEqual(actual, expected)
    }
    
    func testCkeckTime() {
        let reportViewModel = ReportViewModel()
        let actual = reportViewModel.checkingCreatingTime(Date())
        let expected = "20/05/23"
        XCTAssertEqual(actual, expected)
    }

}
