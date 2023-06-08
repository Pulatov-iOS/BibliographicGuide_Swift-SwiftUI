//
//  AuthorizationRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import FirebaseAuth

let globalAuthorizationRepository = AuthorizationRepository()

final class AuthorizationRepository: ObservableObject {

    func authorizationWithEmail(email: String, password: String, completion: @escaping (Bool, String)->Void){
        Auth.auth().signIn(withEmail: email, password: password){
            (res, err) in
            if err != nil{ //  Работа с ошибками
                completion(false, (err?.localizedDescription)!)
                return
            }
            UserDefaults.standard.set(res?.user.uid, forKey: "userId") // Сохраним ID пользователя
            completion(true, (res?.user.uid)!)
        }
    }

    func registrationWithEmail(email: String, password: String, completion: @escaping (Bool, String)->Void){
        
        Auth.auth().createUser(withEmail: email, password: password){
            (res, err) in
            if err != nil{
                completion(false, (err?.localizedDescription)!)
                return
            }
            UserDefaults.standard.set(res?.user.uid, forKey: "userId") // Сохраним ID пользователя
            completion(true,(res?.user.uid)!)
        }
    }
}
