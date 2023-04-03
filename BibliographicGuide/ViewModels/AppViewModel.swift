//
//  AppViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import Foundation

class AppViewModel: ObservableObject {
    
    @Published var status: Bool
    @Published var userId: String
    
    init(){
        status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
        userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    }
}
