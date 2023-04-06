//
//  RegistrationViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 5.04.23.
//

import Foundation

final class RegistrationViewModel: ObservableObject {
    
    @Published var authorizationRepository = AuthorizationRepository()
    @Published var userInformationRepository = UserInformationRepository()
    
    func registrationWithEmail(email: String, password: String, completion: @escaping
                                (Bool, String)->Void) {
        authorizationRepository.registrationWithEmail(email: email, password: password){
            (verified, status) in
            if !verified {
                completion(false, status)
            }
            else{
                let randomInt = Int.random(in: 10000000..<99999999)
                let userName = "nick" + String(randomInt)
                let newUserInformation = UserInformation(role: "user", userName: userName, blockingChat: false, dateUnblockingChat: Date(), blockingAccount: false)
                self.userInformationRepository.addUserInformation(userInformation: newUserInformation, userId: status){
                    (verified, status) in
                    if !verified {
                        // удалить пользователя если ошибка
                        completion(false, status)
                    }
                    else{
                        completion(true, status)
                    }
                }
            }
        }
    }
}
