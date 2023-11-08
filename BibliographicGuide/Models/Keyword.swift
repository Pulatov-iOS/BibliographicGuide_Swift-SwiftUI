//
//  Keyword.swift
//  BibliographicGuide
//
//  Created by Alexander on 30.04.23.
//

import FirebaseFirestoreSwift

struct Keyword: Identifiable, Codable, Equatable {
    
    // MARK: - Public properties
    @DocumentID var id: String?
    var name: String
    
}
