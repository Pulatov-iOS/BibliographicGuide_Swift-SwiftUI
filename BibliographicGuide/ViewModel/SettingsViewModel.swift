//
//  SettingsViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 30.03.23.
//

import Foundation

class SettingsViewModel: ObservableObject {
    

    @Published var userRights = UsersRights()
    
    init(){
        userRights.id = "1"
        userRights.nickname = "ddd"
    }
    
}
