//
//  SettingsViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import Foundation
import Combine

final class UserInformationListViewModel: ObservableObject {
    
    let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    
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
    
    func getUserName() -> String{
        let userName = usersInformationViewModel.filter { (item) -> Bool in
            item.id == userId
        }
        return userName.first?.userInformation.userName ?? "userName"
    }
    
    func updateUserInformation(_ newUserName: String, completion: @escaping (Bool, String)->Void){
        if(newUserName == ""){
            completion(false, "Введите новое имя пользователя.")
        }
        else{
            // проверка нет ли такого имени пользователя
            let userName = usersInformationViewModel.filter { (item) -> Bool in
                item.userInformation.userName.lowercased() == newUserName.lowercased()
            }
            if(userName.first?.userInformation.id == nil){
                userInformationRepository.updateUserInformation(userId: userId, newUserName: newUserName){
                    (verified, status) in
                    if !verified {
                        completion(false, "Ошибка при запросе обновления имени пользователя.")
                    }
                    else{
                        completion(true, "Имя пользователя обновлено успешно.")
                    }
                }
            }
            else{
                completion(false, "Данное имя пользователя уже занято.")
            }
        }
    }
    
    func exitOfAccount(){
        UserDefaults.standard.set(false, forKey: "status")
        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
    }
}
