//
//  AuthorizationViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import Combine
import Foundation

final class AuthorizationViewModel: ObservableObject {
    
    @Published var authorizationRepository = globalAuthorizationRepository
    @Published var userInformationRepository = globalUserInformationRepository
    @Published var currentUserInformation: UserInformation?
    
    @Published var statusCheckEmail = false
    @Published var statusCheckEmailPassword = false
    @Published var textAuthorizationError = ""
    
    func authorizationWithEmail(email: String, password: String, completion: @escaping
                                (Bool, [String])->Void) {
        if(email != "" && password != ""){
            authorizationRepository.authorizationWithEmail(email: email, password: password){
                (verified, status) in
                if !verified {
                    if(status == "The email address is badly formatted."){
                        completion(false, ["Неверный формат email!", "Повторите попытку или зарегистрируйте новый аккаунт"])
                        self.statusCheckEmail = true
                        self.textAuthorizationError = "Неверный формат email"
                    }
                    else{
                        if(status == "There is no user record corresponding to this identifier. The user may have been deleted."){
                            completion(false, ["Неверный email или пароль!", "Повторите попытку или зарегистрируйте новый аккаунт"])
                            self.statusCheckEmailPassword = true
                            self.textAuthorizationError = "Неверный email или пароль"
                        }
                        else{
                            if(status == "The password is invalid or the user does not have a password."){
                                completion(false, ["Неверный email или пароль!", "Повторите попытку или зарегистрируйте новый аккаунт"])
                                self.statusCheckEmailPassword = true
                                self.textAuthorizationError = "Неверный email или пароль"
                            }
                            else{
                                completion(false, ["Ошибка авторизации!", "Проверьте подключение к сети или повторите попытку позже", ""])
                            }
                        }
                    }
                }
                else{
                    self.userInformationRepository.getCurrentUserInformation(status){ (verified, idMessage) in
                        if !verified {
                            completion(false, ["Ошибка авторизации!", "Проверьте подключение к сети или повторите попытку позже", ""])
                        }
                        else{
                            if(!((idMessage.blockingAccount))){
                                completion(true, [status])
                            }
                            else{
                                completion(false, ["Заблокирован!", "Ваша учетная запись заблокирована.\nПричина: \(idMessage.reasonBlockingAccount)", ""])
                            }
                        }
                    }
                }
            }
        }
        else{
            completion(false, ["Введите email и пароль!", "Заполните поля email и пароль, и повторите попытку"])
            self.statusCheckEmailPassword = true
            self.textAuthorizationError = "Введите email и пароль"
        }
    }
}
