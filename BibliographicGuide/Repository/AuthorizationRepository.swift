//
//  AuthorizationRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import FirebaseAuth

final class AuthorizationRepository: ObservableObject {

    func authorizationWithEmail(email: String, password: String, completion: @escaping (Bool, String)->Void){
        
        Auth.auth().signIn(withEmail: email, password: password){
            (res, err) in
            if err != nil{ //  Работа с ошибками
                completion(false, (err?.localizedDescription)!)
                return
            }
            completion(true, (res?.user.email)!)
            
            UserDefaults.standard.set(res?.user.uid, forKey: "userId") // Сохраним ID пользователя
        }
    }

    func registrationWithEmail(email: String, password: String, completion: @escaping (Bool, String)->Void){
        
        Auth.auth().createUser(withEmail: email, password: password){
            (res, err) in
            if err != nil{
                completion(false, (err?.localizedDescription)!)
                return
            }
            completion(true,(res?.user.uid)!)
            
            UserDefaults.standard.set(res?.user.uid, forKey: "userId") // Сохраним ID пользователя
        }
    }
}
