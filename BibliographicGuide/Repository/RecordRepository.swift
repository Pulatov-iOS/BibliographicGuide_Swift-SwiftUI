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
    
    func addRecord(_ record: Record, completion: @escaping (Bool, String)->Void){
        do {
            _ = try db.collection(path).addDocument(from: record)
        } catch {
            completion(false, "Ошибка при добавлении записи")
            fatalError("Adding a record failed")
        }
        completion(true, "Запись успешно добавлена")
    }
    
    func updateRecord(_ record: Record, completion: @escaping (Bool, String)->Void){
        guard let documentId = record.id else { return }
        do {
            try db.collection(path).document(documentId).setData(from: record)
        } catch {
            completion(false, "Ошибка при обновлении записи")
            fatalError("Ошибка при обновлении записи")
        }
        completion(true, "Запись успешно обновлена")
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
