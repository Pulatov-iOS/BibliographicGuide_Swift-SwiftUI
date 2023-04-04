//
//  RecordRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class RecordRepository: ObservableObject {
    
    private let path = "Records"
    private let db = Firestore.firestore()
    @Published var records: [Record] = []
    
    init(){
        fetchRecords()
    }
    
    func fetchRecords(){
        db.collection(path).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.records = snapshot?.documents.compactMap {
                try? $0.data(as: Record.self)
            } ?? []
        }
    }
    
    func addRecord(_ record: Record){
        do {
            _ = try db.collection(path).addDocument(from: record)
        } catch {
            fatalError("Adding a record failed")
        }
    }
    
    func updateRecord(_ record: Record){
        guard let documentId = record.id else { return }
        do {
            try db.collection(path).document(documentId).setData(from: record)
        } catch {
            fatalError("Ошибка при обновлении записи")
        }
    }
    
    func removeRecord(_ record: Record){
        guard let documentId = record.id else { return }
        db.collection(path).document(documentId).delete { error in
            if let error = error {
                print("Нe удалось удалить запись: \(error.localizedDescription)")
            }
        }
    }
    
}
