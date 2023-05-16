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
    var selectedKeywordsSearch = [""]
    
    init(){
        fetchKeywords()
    }
    
    func fetchKeywords(){
        db.collection(pathKeywords).order(by: "name").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.keywords = snapshot?.documents.compactMap {
                try? $0.data(as: Keyword.self)
            } ?? []
        }
        sortingKeywords()
    }
    
    func addKeyword(_ keyword: Keyword, completion: @escaping (Bool, String)->Void) {
        do {
            _ = try db.collection(pathKeywords).addDocument(from: keyword)
            completion(true, "")
        } catch {
            completion(false, "")
            print("Ошибка при добавлении сообщения")
        }
    }
    
    func updateKeyword(_ keyword: Keyword, completion: @escaping (Bool, String)->Void) {
        guard let documentId = keyword.id else { return }
        do {
            try db.collection(pathKeywords).document(documentId).setData(from: keyword)
            completion(true, "")
        } catch {
            completion(false, "")
            print("Ошибка при обновлении ключевого слова")
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
    
    func sortingKeywords(){
        self.keywords.sort(by: {
            selectedKeywordsSearch.contains($0.id ?? "") && !selectedKeywordsSearch.contains($1.id ?? "")
        })
    }
}
