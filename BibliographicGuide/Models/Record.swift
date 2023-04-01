//
//  Record.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import FirebaseFirestoreSwift

struct Record: Identifiable, Codable {
    
    @DocumentID var id: String?
    var idUsers: String //[String]
    var datesChange: String //[String] or [date]
    var title: String
    var year: Int
    var keywords: String // [String]
    var authors: String
    var linkDoi: String
    var linkWebsite: String
    var journalName: String
    var journalNumber: String
    var pageNumbers: String
    var description: String
    var idPhotoTitle: String
    var idPhotoRecord: String //[String]
    var idPdfRecord: String
    
}
