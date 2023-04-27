//
//  UserInformationViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 5.04.23.
//

import Combine

final class UserInformationViewModel: ObservableObject, Identifiable {
    
    @Published var userInformation: UserInformation
    
    var id = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(userInformation: UserInformation){
        self.userInformation = userInformation
        $userInformation
            .compactMap{ $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
