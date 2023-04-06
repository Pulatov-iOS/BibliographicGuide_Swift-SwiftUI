//
//  UserInformationRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 5.04.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserInformationRepository: ObservableObject {
    
    private let path = "UsersInformation"
    private let db = Firestore.firestore()
    @Published var usersInformation: [UserInformation] = []
    
    init(){
        fetchUsersInformation()
    }
    
    func fetchUsersInformation(){
        db.collection(path).addSnapshotListener { (snapshot, error) in
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
        db.collection(path).document(userId).setData(["role": "user", "userName": userInformation.userName,
                                                      "blockingChat": userInformation.blockingChat,
                                                      "dateUnblockingChat": userInformation.dateUnblockingChat,
                                                      "blockingAccount": userInformation.blockingAccount]){
            error in
            if let error = error{
                print(error.localizedDescription)
                completion(false, "Adding a userInformation failed")
            }
        }
        completion(true, "Ok")
    }
}
