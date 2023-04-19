//
//  Record.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import FirebaseFirestoreSwift

struct Record: Identifiable, Codable, Equatable {
    
    @DocumentID var id: String?
    var idUsers: [String]
    var dateCreation: Date
    var datesChange: [Date]
    var title: String
    var year: Int
    var keywords: [String]
    var authors: String // [String]
    var linkDoi: String
    var linkWebsite: String
    var journalName: String
    var journalNumber: String
    var pageNumbers: String
    var description: String
    var idImageTitle: String
    var idImagesRecord: [String]
    var idPdfRecord: String
    
}
