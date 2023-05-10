//
//  Message.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, Equatable {
    
    @DocumentID var id: String?
    var idUser: String
    var typeMessage: String
    @ServerTimestamp
    var date: Date?
    var text: String
    var countImages: Int
    var replyIdMessage: String
    var editing: Bool
    
}
