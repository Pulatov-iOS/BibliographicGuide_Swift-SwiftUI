//
//  AuthorizationViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import Foundation

final class AuthorizationViewModel: ObservableObject {
    
    @Published var authorizationRepository = AuthorizationRepository()
  
    func authorizationWithEmail(email: String, password: String, completion: @escaping
                                (Bool, String)->Void) {
        authorizationRepository.authorizationWithEmail(email: email, password: password){
            (verified, status) in
            if !verified {
                completion(false, status)
            }
            else{
                completion(true, status)
            }
        }
    }
    
}
