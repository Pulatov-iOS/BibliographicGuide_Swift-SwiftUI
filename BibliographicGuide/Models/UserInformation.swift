//
//  UserInformation.swift
//  BibliographicGuide
//
//  Created by Alexander on 5.04.23.
//

import FirebaseFirestoreSwift

struct UserInformation: Identifiable, Codable {
    
    @DocumentID var id: String?
    var role: String
    var userName: String
    var blockingChat: Bool
    var blockingAccount: Bool
    var reasonBlockingAccount: String
    
}
