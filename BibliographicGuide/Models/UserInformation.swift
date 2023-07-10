//
//  UserInformation.swift
//  BibliographicGuide
//
//  Created by Alexander on 5.04.23.
//

import FirebaseFirestoreSwift

struct UserInformation: Identifiable, Codable, Equatable {
    
    @DocumentID var id: String?
    var role: String
    var userName: String
    var updatingImage: Int
    var blockingChat: Bool
    var blockingAccount: Bool
    var reasonBlockingAccount: String
    var language: String
    
}
