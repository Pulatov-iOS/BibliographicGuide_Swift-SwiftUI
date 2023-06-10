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
    @Published var searchUsersInformation: [UserInformationViewModel] = []
    
    @Published var keywordRepository = globalKeywordRepository
    @Published var keywords: [Keyword] = []
    @Published var searchKeywords: [Keyword] = []
    
    private var recordRepository = globalRecordRepository
    
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
    
    func fetchUsersInformationSearch(SearchString: String){
        if(SearchString != ""){
            searchUsersInformation = usersInformationViewModel.filter{
                $0.userInformation.userName.lowercased().contains(SearchString.lowercased())
            }
        }
        else{
            searchUsersInformation = usersInformationViewModel
        }
    }
    
    func getСurrentUserInformation() -> UserInformation {
        let userName = usersInformationViewModel.filter { (item) -> Bool in
            item.id == userId
        }
        return userName.first?.userInformation ?? UserInformation(role: "", userName: "", blockingChat: true, blockingAccount: true, reasonBlockingAccount: "")
    }
    
    func getСurrentIdUser() -> String {
        return userId
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
    
    func updateChatLock(idUser: String, blockingChat: Bool, completion: @escaping (Bool, String)->Void){
        userInformationRepository.updateChatLock(idUser: idUser, blockingChat: blockingChat) { (verified, status) in
            if !verified {
                completion(false, "Ошибка!")
            }
            else{
                completion(true, "Успешно!")
            }
        }
    }
    
    func updateAccountLock(idUser: String, blockingAccount: Bool, completion: @escaping (Bool, String)->Void) {
        userInformationRepository.updateAccountLock(idUser: idUser, blockingAccount: blockingAccount){ (verified, status) in
            if !verified {
                completion(false, "Ошибка!")
            }
            else{
                completion(true, "Успешно!")
            }
        }
    }
    
    func updateRoleReasonBlockingUserName(idUser: String, role: String, reasonBlocking: String, newUserName: String, completion: @escaping (Bool, String)->Void) {
        if(newUserName != ""){
            // проверка нет ли такого имени пользователя
            let userName = usersInformationViewModel.filter { (item) -> Bool in
                item.userInformation.userName.lowercased() == newUserName.lowercased()
            }
            if(userName.first?.userInformation.id == nil){
                userInformationRepository.updateRoleReasonBlockingUserName(idUser: idUser, role: role, reasonBlocking: reasonBlocking, userName: newUserName){ (verified, status) in
                    if !verified {
                        completion(false, "Проверьте подключение к сети и повторите ошибку.")
                    }
                    else{
                        completion(true, "Данные пользователя успешно обновлены.")
                    }
                }
            }
            else{
                completion(false, "Данное имя пользователя уже занято.")
            }
        }
        else{
            userInformationRepository.updateRoleReasonBlocking(idUser: idUser, role: role, reasonBlocking: reasonBlocking){ (verified, status) in
                if !verified {
                    completion(false, "Проверьте подключение к сети и повторите ошибку.")
                }
                else{
                    completion(true, "Данные пользователя успешно обновлены.")
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
    
    func removeKeyword(_ keyword: Keyword, completion: @escaping (Bool)->Void) {
        var recordsWithCurrentKeyword: [Record] = []
        recordRepository.getRecordsWithCurrentKeyword(keyword){ (error, records) in
            if !error {
                completion(false)
            }
            else{
                recordsWithCurrentKeyword = records
                self.keywordRepository.removeKeyword(keyword){ error in
                    if !error {
                        completion(false)
                    }
                    else{
                        for record in recordsWithCurrentKeyword{
                            var newRecord = record
                            var newIdKeywords = newRecord.idKeywords
                            if newIdKeywords.contains(keyword.id ?? ""){
                                newIdKeywords.remove(at: newIdKeywords.firstIndex(of: keyword.id ?? "") ?? 999999)
                            }
                            newRecord.idKeywords = newIdKeywords
                            self.recordRepository.updateRecord(record: newRecord, imageTitle: Data(), newImageRecord: false) { (error, status) in
                            }
                        }
                        completion(true)
                    }
                }
            }
        }
    }
    
    func exitOfAccount(){
        UserDefaults.standard.set(false, forKey: "status")
        UserDefaults.standard.set("", forKey: "userId")
        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
    }
}
