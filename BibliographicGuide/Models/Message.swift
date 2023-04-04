//
//  Message.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import FirebaseFirestoreSwift

struct Message: Identifiable, Codable {
    
    @DocumentID var id: String?
    var idUser: String
    var typeMessage: String
    var date: Date
    var text: String
    var idFiles: [String]
    var editing: Bool
    
}
