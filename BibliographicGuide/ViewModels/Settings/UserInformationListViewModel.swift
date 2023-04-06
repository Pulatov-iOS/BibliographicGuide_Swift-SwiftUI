//
//  SettingsViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import Foundation
import Combine

final class UserInformationListViewModel: ObservableObject {
    
    @Published var userInformationRepository = UserInformationRepository()
    @Published var usersInformationViewModel: [UserInformationViewModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        userInformationRepository.$usersInformation
            .map { userInformation in
                userInformation.map(UserInformationViewModel.init)
            }
            .assign(to: \.usersInformationViewModel, on: self)
            .store(in: &cancellables)
    }
    
    func exitOfAccount(){
        UserDefaults.standard.set(false, forKey: "status")
        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
    }
    
}
