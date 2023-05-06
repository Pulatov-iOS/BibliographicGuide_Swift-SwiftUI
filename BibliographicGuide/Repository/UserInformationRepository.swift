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
    
    func addUserInformation(userInformation: UserInformation, userId: String, completion: @escaping (Bool, String)->Void){
        db.collection(pathUserInformation).document(userId).setData(["role": "user", "userName": userInformation.userName,
                                                      "blockingChat": userInformation.blockingChat,
                                                      "blockingAccount": userInformation.blockingAccount]){
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
