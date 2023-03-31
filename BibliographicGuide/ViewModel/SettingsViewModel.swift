//
//  SettingsViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 30.03.23.
//

import Foundation

import FirebaseCore
import FirebaseFirestore

class SettingsViewModel: ObservableObject {
    
    
    @Published var userRights = [UsersRights]()
    

    
    
//    func fetch(){
//        var db = Firestore.firestore()
//        var linkUser: ListenerRegistration! // удалить ее!!!
//
//        userRights.removeAll()
//        linkUser = db.collection("UserRights").document(UserDefaults.standard.value(forKey: "userId") as? String ?? "1").addSnapshotListener { (querySnapshot, error) in
//            guard let document = querySnapshot else{
//                print("No documents")
//                return
//            }
//
//            let data = document.data()
//            let id = document.documentID // Получаем ID
//            let nickname = data?["nickname"] as? String ?? ""
//            let email = data?["email"] as? String ?? ""
//            let administrator = data?["administrator"] as? Bool ?? false
//            let rightCreation = data?["rightCreation"] as? Bool ?? false
//            let rightEditing = data?["rightEditing"] as? Bool ?? false
//            let rightDeletion = data?["rightDeletion"] as? Bool ?? false
//            let recordOrder = data?["recordOrder"] as? String ?? ""
//            let user = UserRights(id: id, nickname: nickname, email: email, administrator: administrator, rightCreation: rightCreation, rightEditing: rightEditing, rightDeletion: rightDeletion, recordOrder: recordOrder)
//
//            self.userRights.append(user)
//        }
//    }
    
    func createUser(){
        var db = Firestore.firestore()
        let ref = db.collection("UserRights").document("userId") // .document("MyID"), сейчас Auto
        
        let randomInt = Int.random(in: 10000000..<99999999)
        let nick = "nick" + String(randomInt)
        
        ref.setData(["nickname": nick, "email": "email", "administrator": false, // email изменить!!
                     "rightCreation": false, "rightEditing": false, "rightDeletion": false, "recordOrder": "title"]){
            error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
}
