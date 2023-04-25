//
//  Report.swift
//  BibliographicGuide
//
//  Created by Alexander on 25.04.23.
//

import FirebaseFirestoreSwift

struct Report: Identifiable, Codable {
    
    @DocumentID var id: String?
    var idUser: String
    var idRecords: [String]
    var date: Date
    
}
