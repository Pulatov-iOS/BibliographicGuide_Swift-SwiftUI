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
    
    @Published var statusCheckEmail = true
    @Published var statusCheckPassword = [false, false, false]
    
    private let minLength = 6
    private lazy var regexEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private lazy var regexQuantityCharactersPassword = "^.{\(minLength),}$"
    private lazy var regexUppercaseLetterPassword = "[A-Z]{1,}"
    private lazy var regexLowercaseLetterPassword = "[a-z]{1,}"
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{\(minLength),}$"
    
    func registrationWithEmail(email: String, password: String, completion: @escaping
                                (Bool, [String])->Void) {
        checkEmail(email: email)
        if(statusCheckEmail == true && statusCheckPassword[0] == true && statusCheckPassword[1] == true && statusCheckPassword[2] == true){
            authorizationRepository.registrationWithEmail(email: email, password: password){
                (verified, status) in
                if !verified {
                    if(status == "Network error (such as timeout, interrupted connection or unreachable host) has occurred."){
                        completion(false, ["Ошибка регистрации!", "Проверьте подключение к сети или повторите попытку позже"])
                    }
                    else{
                        completion(false, ["Ошибка регистрации!", "Повторите попытку позже"])
                    }
                }
                else{
                    let randomInt = Int.random(in: 10000000..<99999999)
                    let userName = "nick" + String(randomInt)
                    let newUserInformation = UserInformation(role: "user", userName: userName, blockingChat: false, blockingAccount: false)
                    self.userInformationRepository.addUserInformation(userInformation: newUserInformation, userId: status){
                        (verified, status) in
                        if !verified {
                            // удалить пользователя если ошибка
                        }
                        else{
                            completion(true, ["Успешно", ""])
                        }
                    }
                }
            }
        }
        else{
            completion(false, ["Неверно заполнены данные!", "Проверьте введенные вами данные и повторите попытку"])
        }
    }
    
    func checkEmail(email: String) {
        if(email.matches(regexEmail)){
            statusCheckEmail = true
        }
        else{
            statusCheckEmail = false
        }
    }
    
    func checkPassword(password: String) {
        if(password.matches(regexQuantityCharactersPassword)){
            statusCheckPassword[0] = true
        }
        if(password.matches(regexLowercaseLetterPassword)){
            statusCheckPassword[1] = true
        }
        if(password.matches(regexUppercaseLetterPassword)){
            statusCheckPassword[2] = true
        }
    }
}

extension String{
    func matches(_ regex: String) -> Bool{
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
