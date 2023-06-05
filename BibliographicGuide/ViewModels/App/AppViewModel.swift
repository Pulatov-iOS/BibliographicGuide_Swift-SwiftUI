//
//  TestViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 11.05.23.
//

import Foundation
import Combine

final class AppViewModel: ObservableObject {
    
    var userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    
    @Published var userInformationRepository = globalUserInformationRepository
    @Published var currentUserInformation: UserInformation?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        
        if(userId != ""){
            fetchCurrentUserInformation(userId)
        }
        
        userInformationRepository.$currentUserInformation
            .assign(to: \.currentUserInformation, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){
            (_) in
            let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
            self.userId = userId
            if(self.userId != ""){
                self.fetchCurrentUserInformation(self.userId)
            }
        }
    }
    
    func fetchCurrentUserInformation(_ idUser: String){
        userInformationRepository.removeLinkCurrentUserInformation()
        userInformationRepository.fetchCurrentUserInformation(idUser)
    }
}
