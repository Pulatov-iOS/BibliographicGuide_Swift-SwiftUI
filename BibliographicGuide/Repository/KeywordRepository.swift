//
//  KeywordRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 30.04.23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

let globalKeywordRepository = KeywordRepository()

final class KeywordRepository: ObservableObject {
    
    private let pathKeywords = "Keywords"
    private let db = Firestore.firestore()
    @Published var keywords: [Keyword] = []
    
    init(){
        fetchKeywords()
    }
    
    func fetchKeywords(){
        db.collection(pathKeywords).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.keywords = snapshot?.documents.compactMap {
                try? $0.data(as: Keyword.self)
            } ?? []
        }
    }
    
    func addKeyword(_ keyword: Keyword){
        do {
            _ = try db.collection(pathKeywords).addDocument(from: keyword)
        } catch {
            fatalError("Adding a message failed")
        }
    }
    
    func updateKeyword(_ keyword: Keyword){
        guard let documentId = keyword.id else { return }
        do {
            try db.collection(pathKeywords).document(documentId).setData(from: keyword)
        } catch {
            fatalError("Ошибка при обновлении ключевого слова")
        }
    }
    
    func removeKeyword(_ keyword: Keyword){
        guard let documentId = keyword.id else { return }
        db.collection(pathKeywords).document(documentId).delete { error in
            if let error = error {
                print("Нe удалось удалить ключевое слово: \(error.localizedDescription)")
            }
        }
    }
}
