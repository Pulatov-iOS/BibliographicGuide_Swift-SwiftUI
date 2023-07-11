//
//  UserInformationRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 5.04.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

let globalUserInformationRepository = UserInformationRepository()

final class UserInformationRepository: ObservableObject {
    
    private let pathUserInformation = "UsersInformation"
    private let pathImageAccount = "ImageAccount"
    private let userName = "userName"
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    @Published var usersInformation: [UserInformation] = []
    @Published var currentUserInformation: UserInformation?
    
    private var linkCurrentUserInformation: ListenerRegistration!
    
    init(){
        fetchUsersInformation()
    }
    
    deinit{
        removeLinkCurrentUserInformation()
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
        linkCurrentUserInformation = db.collection(pathUserInformation).document(idUser).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                return
            }
            guard let data = document.data() else {
                return
            }
            let role = data["role"] as? String ?? ""
            let userName = data["userName"] as? String ?? ""
            let updatingImage = data["updatingImage"] as? Int ?? 0
            let blockingAccount = data["blockingAccount"] as? Bool ?? true
            let blockingChat = data["blockingChat"] as? Bool ?? true
            let reasonBlockingAccount = data["reasonBlockingAccount"] as? String ?? ""
            let language = data["language"] as? String ?? ""
            self.currentUserInformation = UserInformation(role: role, userName: userName, updatingImage: updatingImage, blockingChat: blockingChat, blockingAccount: blockingAccount, reasonBlockingAccount: reasonBlockingAccount, language: language)
        }
    }
    
    func removeLinkCurrentUserInformation(){
        if(linkCurrentUserInformation != nil){
            linkCurrentUserInformation.remove()
        }
    }
    
    func getCurrentUserInformation(_ idUser: String, completion: @escaping (Bool, UserInformation)->Void) {
        db.collection(pathUserInformation).document(idUser).getDocument() { (snapshot, error) in
            guard let document = snapshot else {
                completion(false,  self.currentUserInformation ?? UserInformation(role: "", userName: "", updatingImage: 0, blockingChat: false, blockingAccount: false, reasonBlockingAccount: "", language: ""))
                return
            }
            guard let data = document.data() else {
                completion(false,  self.currentUserInformation ?? UserInformation(role: "", userName: "", updatingImage: 0, blockingChat: false, blockingAccount: false, reasonBlockingAccount: "", language: ""))
                return
            }
            let role = data["role"] as? String ?? ""
            let userName = data["userName"] as? String ?? ""
            let updatingImage = data["updatingImage"] as? Int ?? 0
            let blockingAccount = data["blockingAccount"] as? Bool ?? true
            let blockingChat = data["blockingChat"] as? Bool ?? true
            let reasonBlockingAccount = data["reasonBlockingAccount"] as? String ?? ""
            let language = data["language"] as? String ?? ""
            self.currentUserInformation = UserInformation(role: role, userName: userName, updatingImage: updatingImage, blockingChat: blockingChat, blockingAccount: blockingAccount, reasonBlockingAccount: reasonBlockingAccount, language: language)
            completion(true,  self.currentUserInformation ?? UserInformation(role: "", userName: "", updatingImage: 0, blockingChat: false, blockingAccount: false, reasonBlockingAccount: "", language: ""))
        }
    }
    
    func addUserInformation(userInformation: UserInformation, userId: String, completion: @escaping (Bool, String)->Void) {
        db.collection(pathUserInformation).document(userId).setData(["role": "reader", "userName": userInformation.userName,
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
    
    func updateUserInformation(userId: String, newUserName: String, completion: @escaping (Bool, String)->Void) {
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
    
    func updateChatLock(idUser: String, blockingChat: Bool, completion: @escaping (Bool, String)->Void) {
        db.collection(pathUserInformation).document(idUser).updateData([
            "blockingChat": blockingChat,
        ]) { err in
            if err != nil {
                completion(false, "Ошибка при обновлении")
            } else {
                completion(true, "Обновлено успешно")
            }
        }
    }
    
    func updateAccountLock(idUser: String, blockingAccount: Bool, completion: @escaping (Bool, String)->Void) {
        db.collection(pathUserInformation).document(idUser).updateData([
            "blockingAccount": blockingAccount
        ]) { err in
            if err != nil {
                completion(false, "Ошибка при обновлении")
            } else {
                completion(true, "Обновлено успешно")
            }
        }
    }
    
    func updateRoleReasonBlockingUserName(idUser: String, role: String, reasonBlocking: String, userName: String, completion: @escaping (Bool, String)->Void) {
        db.collection(pathUserInformation).document(idUser).updateData([
            "role": role,
            "reasonBlockingAccount": reasonBlocking,
            "userName": userName
        ]) { err in
            if err != nil {
                completion(false, "Ошибка при обновлении")
            } else {
                completion(true, "Обновлено успешно")
            }
        }
    }
    
    func updateRoleReasonBlocking(idUser: String, role: String, reasonBlocking: String, completion: @escaping (Bool, String)->Void) {
        db.collection(pathUserInformation).document(idUser).updateData([
            "role": role,
            "reasonBlockingAccount": reasonBlocking,
        ]) { err in
            if err != nil {
                completion(false, "Ошибка при обновлении")
            } else {
                completion(true, "Обновлено успешно")
            }
        }
    }
    
    func updateImageAccount(_ userInformation: UserInformation){
        var updateImage = 0
        if(userInformation.updatingImage < 100000){
            updateImage = userInformation.updatingImage + 1
        }
        else{
            updateImage = 0
        }
        db.collection(pathUserInformation).document(userInformation.id ?? "").updateData([
            "updatingImage": updateImage
        ]) { error in
            if error != nil {
                print("Error")
            }
        }
    }
    
    func updateLanguage(idUser: String, language: String, completion: @escaping (Bool, String)->Void) {
        db.collection(pathUserInformation).document(idUser).updateData([
            "language": language,
        ]) { err in
            if err != nil {
                completion(false, "Ошибка при обновлении")
            } else {
                completion(true, "Обновлено успешно")
            }
        }
    }
    
    func addImageAccount(idImageAccount: String, imageAccount: Data, completion: @escaping (Bool, String)->Void) {
        let referenceSorage = storage.reference() // Создаем ссылку на хранилище
        let pathRef = referenceSorage.child(pathImageAccount) // Создаем дочернюю ссылку
    
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        pathRef.child(idImageAccount).putData(imageAccount, metadata: metadata){
            metadata, error in
            guard let metadata = metadata else{
                completion(false, "Ошибка")
                return
            }
            completion(true, "Успешно")
        }
    }
    
    func getImageUrl(pathImage: String, idImage: String, completion: @escaping (Bool, URL)->Void) {
        var imageUrl = URL(string: "")
        let storage = storage.reference(withPath: pathImage + "/" + idImage)
           storage.downloadURL { (url, error) in
               if error != nil {
                   completion(false, URL(string: "https://firebase.google.com/")!)
               }
               else{
                   imageUrl = url!
                   completion(true, (imageUrl ?? (URL(string: "")))!)
               }
           }
    }
}
