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
                                (Bool, [String])->Void) {
        if(email != "" && password != ""){
            authorizationRepository.authorizationWithEmail(email: email, password: password){
                (verified, status) in
                if !verified {
                    if(status == "The email address is badly formatted."){
                        completion(false, ["Неверный формат email!", "Повторите попытку или зарегистрируйте новый аккаунт", "Неверный формат email"])
                    }
                    else{
                        if(status == "There is no user record corresponding to this identifier. The user may have been deleted."){
                            completion(false, ["Неверный email!", "Повторите попытку или зарегистрируйте новый аккаунт", "Неверный email"])
                        }
                        else{
                            if(status == "The password is invalid or the user does not have a password."){
                                completion(false, ["Неверный пароль!", "Повторите попытку или зарегистрируйте новый аккаунт", "Неверный пароль"])
                            }
                            else{
                                completion(false, ["Ошибка авторизации!", "Проверьте подключение к сети или повторите попытку позже", ""])
                            }
                        }
                    }
                }
                else{
                    completion(true, ["Ок"])
                }
            }
        }
        else{
            completion(false, ["Введите email и пароль!", "Заполните поля email и пароль, и повторите попытку", "Введите email и пароль"])
        }
    }
}
