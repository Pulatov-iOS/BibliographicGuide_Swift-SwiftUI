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
    
    private var linkFetchKeywords: ListenerRegistration!
    
    init(){
        fetchKeywords()
    }
    
    deinit{
        removeLinkFetchKeywords()
    }
    
    func fetchKeywords(){
        linkFetchKeywords = db.collection(pathKeywords).order(by: "name").addSnapshotListener { (snapshot, error) in
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
    
    func removeLinkFetchKeywords(){
        if(linkFetchKeywords != nil){
            linkFetchKeywords.remove()
        }
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
    
    func removeKeyword(_ keyword: Keyword, completion: @escaping (Bool)->Void) {
        guard let documentId = keyword.id else { return }
        db.collection(pathKeywords).document(documentId).delete { error in
            if let error = error {
                completion(false)
            }
            else{
                completion(true)
            }
        }
    }
    
    func sortingKeywords(){
        self.keywords.sort(by: {
            selectedKeywordsSearch.contains($0.id ?? "") && !selectedKeywordsSearch.contains($1.id ?? "")
        })
    }
    
    func sortingNameKeywords(){
        self.keywords.sort(by: {
            $0.name < $1.name
        })
    }
}
