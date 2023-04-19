//
//  RecordRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Combine

final class RecordRepository: ObservableObject {
    
    private let pathRecords = "Records"
    private let pathImageTitle = "ImageTitle"
    private let db = Firestore.firestore()
    private let storage = Storage.storage() // Получаем ссылку на службу хранения, используя приложение Firebase по умолчанию
    @Published var records: [Record] = []
    
    init(){
        fetchRecords()
    }
    
    func fetchRecords(){
        db.collection(pathRecords).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.records = snapshot?.documents.compactMap {
                try? $0.data(as: Record.self)
            } ?? []
        }
    }
    
    func addRecord(record: Record, imageTitle: Data, completion: @escaping (Bool, String)->Void){
        do {
            let result = try db.collection(pathRecords).addDocument(from: record)
        
            addImageTitle(idImageTitle: result.documentID, imageTitle: imageTitle){ (verified, status) in
                    if !verified {
                        completion(false, "Ошибка при добавлении записи.")
                    }
                    else{
                        completion(true, "Запись добавлена успешно.")
                    }
            }
        } catch {
            completion(false, "Ошибка при добавлении записи.")
        }
    }
    
    func updateRecord(_ record: Record, completion: @escaping (Bool, String)->Void){
        guard let documentId = record.id else { return }
        do {
            try db.collection(pathRecords).document(documentId).setData(from: record)
        } catch {
            completion(false, "Ошибка при обновлении записи")
            fatalError("Ошибка при обновлении записи")
        }
        completion(true, "Запись успешно обновлена")
    }
    
    func removeRecord(_ record: Record){
        guard let documentId = record.id else { return }
        db.collection(pathRecords).document(documentId).delete { error in
            if let error = error {
                print("Нe удалось удалить запись: \(error.localizedDescription)")
            }
        }
    }
    
    func addImageTitle(idImageTitle: String, imageTitle: Data, completion: @escaping (Bool, String)->Void){
        let referenceSorage = storage.reference() // Создаем ссылку на хранилище
        let pathRef = referenceSorage.child(pathImageTitle) // Создаем дочернюю ссылку
    
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        pathRef.child(idImageTitle).putData(imageTitle, metadata: metadata){
            metadata, error in
            guard let metadata = metadata else{
                completion(false, "Ошибка")
                return
            }
            completion(true, "Успешно")
        }
    }
}
