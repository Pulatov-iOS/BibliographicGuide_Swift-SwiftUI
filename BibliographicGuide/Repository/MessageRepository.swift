//
//  MessageRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

let globalMessageRepository = MessageRepository()

final class MessageRepository: ObservableObject {
    
    private let path = "Messages"
    private let db = Firestore.firestore()
    @Published var messages: [Message] = []
    
    init(){
        fetchMessages()
    }
    
    func fetchMessages(){
        db.collection(path).order(by: "date").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.messages = snapshot?.documents.compactMap {
                try? $0.data(as: Message.self)
            } ?? []
        }
    }
    
    func addMessage(_ message: Message){
        do {
            _ = try db.collection(path).addDocument(from: message)
        } catch {
            fatalError("Adding a message failed")
        }
    }
    
    func updateMessage(_ message: Message){
        guard let documentId = message.id else { return }
        do {
            try db.collection(path).document(documentId).setData(from: message)
        } catch {
            fatalError("Ошибка при обновлении сообщения")
        }
    }
    
    func removeMessage(_ message: Message){
        guard let documentId = message.id else { return }
        db.collection(path).document(documentId).delete { error in
            if let error = error {
                print("Нe удалось удалить сообщение: \(error.localizedDescription)")
            }
        }
    }
}
