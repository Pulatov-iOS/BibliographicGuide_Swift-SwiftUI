//
//  UserInformationRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 5.04.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

let globalUserInformationRepository = UserInformationRepository()

final class UserInformationRepository: ObservableObject {
    
    private let pathUserInformation = "UsersInformation"
    private let userName = "userName"
    private let db = Firestore.firestore()
    @Published var usersInformation: [UserInformation] = []
    @Published var currentUserInformation: UserInformation?
    
    init(){
        fetchUsersInformation()
    }
    
    func fetchUsersInformation(){
        db.collection(pathUserInformation).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.usersInformation = snapshot?.documents.compactMap {
                try? $0.data(as: UserInformation.self)
            } ?? []
        }
    }
    
    func fetchCurrentUserInformation(_ idUser: String){
        db.collection(pathUserInformation).document(idUser).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                return
            }
            guard let data = document.data() else {
                return
            }
            let blockingAccount = data["blockingAccount"] as? Bool ?? true
            let blockingChat = data["blockingChat"] as? Bool ?? true
            let reasonBlockingAccount = data["reasonBlockingAccount"] as? String ?? ""
            let role = data["role"] as? String ?? ""
            let userName = data["userName"] as? String ?? ""
            self.currentUserInformation = UserInformation(role: role, userName: userName, blockingChat: blockingChat, blockingAccount: blockingAccount, reasonBlockingAccount: reasonBlockingAccount)
        }
    }
    
    func getCurrentUserInformation(_ idUser: String, completion: @escaping (Bool, UserInformation)->Void) {
        db.collection(pathUserInformation).document(idUser).getDocument() { (snapshot, error) in
            guard let document = snapshot else {
                completion(false,  self.currentUserInformation ?? UserInformation(role: "", userName: "", blockingChat: false, blockingAccount: false, reasonBlockingAccount: ""))
                return
            }
            guard let data = document.data() else {
                completion(false,  self.currentUserInformation ?? UserInformation(role: "", userName: "", blockingChat: false, blockingAccount: false, reasonBlockingAccount: ""))
                return
            }
            let blockingAccount = data["blockingAccount"] as? Bool ?? true
            let blockingChat = data["blockingChat"] as? Bool ?? true
            let reasonBlockingAccount = data["reasonBlockingAccount"] as? String ?? ""
            let role = data["role"] as? String ?? ""
            let userName = data["userName"] as? String ?? ""
            self.currentUserInformation = UserInformation(role: role, userName: userName, blockingChat: blockingChat, blockingAccount: blockingAccount, reasonBlockingAccount: reasonBlockingAccount)
            completion(true,  self.currentUserInformation ?? UserInformation(role: "", userName: "", blockingChat: false, blockingAccount: false, reasonBlockingAccount: ""))
        }
    }
    
    func addUserInformation(userInformation: UserInformation, userId: String, completion: @escaping (Bool, String)->Void){
        db.collection(pathUserInformation).document(userId).setData(["role": "user", "userName": userInformation.userName,
                                                      "blockingChat": userInformation.blockingChat,
                                                                     "blockingAccount": userInformation.blockingAccount, "reasonBlockingAccount": ""]){
            error in
            if let error = error{
                print(error.localizedDescription)
                completion(false, "Adding a userInformation failed")
            }
        }
        completion(true, "Ok")
    }
    
    func updateUserInformation(userId: String, newUserName: String, completion: @escaping (Bool, String)->Void){
        db.collection(pathUserInformation).document(userId).updateData([
            userName: newUserName
        ]) { err in
            if let err = err {
                completion(false, "error")
            } else {
                completion(true, "success")
            }
        }
    }
    
    func updateAccountLock(idUser: String, blockingChat: Bool, blockingAccount: Bool, completion: @escaping (Bool, String)->Void){
        db.collection(pathUserInformation).document(idUser).updateData([
            "blockingChat": blockingChat,
            "blockingAccount": blockingAccount
        ]) { err in
            if err != nil {
                completion(false, "Ошибка при обновлении")
            } else {
                completion(true, "Обновлено успешно")
            }
        }
    }
}
