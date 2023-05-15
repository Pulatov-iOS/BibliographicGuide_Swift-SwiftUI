//
//  Report.swift
//  BibliographicGuide
//
//  Created by Alexander on 25.04.23.
//

import FirebaseFirestoreSwift

struct Report: Identifiable, Codable, Equatable {
    
    @DocumentID var id: String?
    var idUser: String
    var titleSaveReport: String
    var idRecords: [String]
    @ServerTimestamp
    var date: Date?
    var nameCreatedReport: String
    var authorCreatedReport: String
    
}
