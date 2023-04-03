//
//  SettingsViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    
    func exitOfAccount(){
        UserDefaults.standard.set(false, forKey: "status")
        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
    }
    
}
