//
//  SettingsViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 30.03.23.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var test1: Int
    
    init(){
        test1 = 1
    }
    
}
