//
//  MessageRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

let globalMessageRepository = MessageRepository()

final class MessageRepository: ObservableObject {
    
    private let pathMessages = "Messages"
    private let pathImageMessage = "ImageMessage"
    private let db = Firestore.firestore()
    private let storage = Storage.storage() // Получаем ссылку на службу хранения, используя приложение Firebase по умолчанию
    @Published var messages: [Message] = []
    
    init(){
        fetchMessages()
    }
    
    func fetchMessages(){
        db.collection(pathMessages).order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.messages = snapshot?.documents.compactMap {
                try? $0.data(as: Message.self)
            } ?? []
        }
    }
    
    func addMessage(_ message: Message, imageMessage: [Data], completion: @escaping (Bool, String)->Void){
        var idMessage = ""
        do {
            _ = try idMessage = db.collection(pathMessages).addDocument(from: message).documentID
        } catch {
            fatalError("Adding a message failed")
        }
        if(message.typeMessage == "image"){
            addImageMessage(idImageMessage: idMessage, imageMessage: imageMessage){ (verified, path) in
                if !verified {
                    completion(false, "Error")
                }
                else{
                    completion(true, idMessage)
                }
            }
        }
    }
    
    func updateMessage(_ message: Message){
        guard let documentId = message.id else { return }
        do {
            try db.collection(pathMessages).document(documentId).setData(from: message)
        } catch {
            fatalError("Ошибка при обновлении сообщения")
        }
    }
    
    func removeMessage(_ message: Message){
        guard let documentId = message.id else { return }
        db.collection(pathMessages).document(documentId).delete { error in
            if let error = error {
                print("Нe удалось удалить сообщение: \(error.localizedDescription)")
            }
        }
    }
    
    func addImageMessage(idImageMessage: String, imageMessage: [Data], completion: @escaping (Bool, String)->Void){
        
        let referenceSorage = storage.reference() // Создаем ссылку на хранилище
        let pathRef = referenceSorage.child(pathImageMessage) // Создаем дочернюю ссылку
    
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        var item = 0
        for itemData in imageMessage{
            pathRef.child("\(idImageMessage)_\(item)").putData(itemData, metadata: metadata){
                metadata, error in
                if let metadata = metadata
                {
                    completion(true, metadata.path ?? "")
                } else{
                    completion(false, "")
                    return
                }
            }
            item += 1
        }
        
    }
    
    func getImageMessageUrl(pathImage: String, idImage: String, completion: @escaping (Bool, URL)->Void) {
        var imageUrl = URL(string: "")
        let storage = storage.reference(withPath: pathImage + "/" + idImage)
           storage.downloadURL { (url, error) in
               if error != nil {
                   return
               }
               imageUrl = url!
               completion(true, (imageUrl ?? (URL(string: "https://turbok.by/public/img/no-photo--lg.png")))!)
           }
    }
    
    func getImageAccountUrl(pathImage: String, idImage: String, completion: @escaping (Bool, URL)->Void) {
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
