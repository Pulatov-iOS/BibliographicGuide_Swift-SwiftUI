//
//  Record.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import FirebaseFirestoreSwift

struct Record: Identifiable, Codable, Equatable {
    
    @DocumentID var id: String?
    var idUser: String
    @ServerTimestamp
    var dateCreation: Date?
    @ServerTimestamp
    var dateChange: Date?
    var title: String
    var year: Int
    var idKeywords: [String]
    var authors: String
    var linkDoi: String
    var linkWebsite: String
    var journalName: String
    var journalNumber: String
    var pageNumbers: String
    var description: String
    var updatingImage: Int
    var idUsersReporting: [String]
    var universityRecord: Bool
    
}
