//
//  SettingsViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import Foundation
import Combine

final class UserInformationListViewModel: ObservableObject {
    
    var userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    
    @Published var userInformationRepository = globalUserInformationRepository
    @Published var usersInformationViewModel: [UserInformationViewModel] = []
    
    @Published var keywordRepository = globalKeywordRepository
    @Published var keywords: [Keyword] = []
    @Published var searchKeywords: [Keyword] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        userInformationRepository.$usersInformation
            .map { userInformation in
                userInformation.map(UserInformationViewModel.init)
            }
            .assign(to: \.usersInformationViewModel, on: self)
            .store(in: &cancellables)
        
        keywordRepository.$keywords
            .assign(to: \.keywords, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){
            (_) in
            let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
            self.userId = userId
        }
    }
    
    func getСurrentUserInformation() -> UserInformation{
        let userName = usersInformationViewModel.filter { (item) -> Bool in
            item.id == userId
        }
        return userName.first?.userInformation ?? UserInformation(role: "", userName: "", blockingChat: true, blockingAccount: true, reasonBlockingAccount: "")
    }
    
    func updateUserInformation(newUserName: String, imageAccount: Data, newImageAccount: Bool, completion: @escaping (Bool, String)->Void) {
        if(newUserName == "" && newImageAccount == false){
            completion(false, "Введите новое имя пользователя.")
        }
        else{
            if(newUserName == "" && newImageAccount == true){
                self.userInformationRepository.addImageAccount(idImageAccount: self.userId, imageAccount: imageAccount){ (verified, status) in
                    if !verified {
                        completion(false, "Ошибка при запросе обновления изображения пользователя.")
                    }
                    else{
                        completion(true, "Изображение пользователя успешно обновлено.")
                    }
                }
            }
            else{
                // проверка нет ли такого имени пользователя
                let userName = usersInformationViewModel.filter { (item) -> Bool in
                    item.userInformation.userName.lowercased() == newUserName.lowercased()
                }
                if(userName.first?.userInformation.id == nil){
                    userInformationRepository.updateUserInformation(userId: userId, newUserName: newUserName){ (verified, status) in
                        if !verified {
                            completion(false, "Ошибка при запросе обновления имени пользователя.")
                        }
                        else{
                            if(newImageAccount){
                                self.userInformationRepository.addImageAccount(idImageAccount: self.userId, imageAccount: imageAccount){ (verified, status) in
                                    if !verified {
                                        completion(false, "Ошибка при запросе обновления изображения пользователя.")
                                    }
                                    else{
                                        completion(true, "Имя и изображение пользователя успешно обновлено.")
                                    }
                                }
                            }
                            else{
                                completion(true, "Имя пользователя успешно обновлено.")
                            }
                        }
                    }
                }
                else{
                    completion(false, "Данное имя пользователя уже занято.")
                }
            }
        }
    }
    
    func getImageUrl(pathImage: String, completion: @escaping (Bool, URL)->Void) {
        userInformationRepository.getImageUrl(pathImage: pathImage, idImage: self.userId){ (verified, status) in
            if !verified  {
                completion(false, URL(string: "https://firebase.google.com/")!)
            }
            else{
                completion(true, status)
            }
        }
    }
    
    func fetchKeywordsSearch(SearchString: String){
        if(SearchString != ""){
            searchKeywords = keywords.filter{
                $0.name.lowercased().contains(SearchString.lowercased())
            }
        }
        else{
            searchKeywords = keywords
        }
    }
    
    func addKeyword(_ keyword: Keyword, completion: @escaping (Bool, String)->Void) {
        var newKeyword = keyword
        newKeyword.name = newKeyword.name.lowercased()
        keywordRepository.addKeyword(newKeyword){ (verified, status) in
            if !verified  {
                completion(false, "")
            }
            else{
                completion(true, "")
            }
        }
    }
    
    func updateKeyword(_ keyword: Keyword, completion: @escaping (Bool, String)->Void) {
        var newKeyword = keyword
        newKeyword.name = newKeyword.name.lowercased()
        keywordRepository.updateKeyword(newKeyword){ (verified, status) in
            if !verified  {
                completion(false, "")
            }
            else{
                completion(true, "")
            }
        }
    }
    
    func removeKeyword(_ keyword: Keyword){
        keywordRepository.removeKeyword(keyword)
    }
    
    func exitOfAccount(){
        UserDefaults.standard.set(false, forKey: "status")
        UserDefaults.standard.set("", forKey: "userId")
        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
    }
}
