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

let globalRecordRepository = RecordRepository()

final class RecordRepository: ObservableObject {
    
    private let pathRecords = "Records"
    private let pathImageTitle = "ImageTitle"
    private let db = Firestore.firestore()
    private let storage = Storage.storage() // Получаем ссылку на службу хранения, используя приложение Firebase по умолчанию
    @Published var records: [Record] = []
    @Published var topFiveRecords: [Record] = []
    private var selectedSortingRecords = "title"
    
    init(){
        fetchRecords()
        fetchTopFiveRecords()
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
            self.sortingRecords(sortingRecords: self.selectedSortingRecords)
        }
    }
    
    func fetchTopFiveRecords(){
        db.collection(pathRecords).order(by: "dateChange",descending: true).limit(to: 5).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.topFiveRecords = snapshot?.documents.compactMap {
                try? $0.data(as: Record.self)
            } ?? []
        }
    }
    
    func getRecordsWithCurrentKeyword(_ keyword: Keyword, completion: @escaping (Bool, [Record])->Void) {
        var records: [Record] = []
        db.collection(pathRecords).whereField("idKeywords", arrayContains: keyword.id ?? "")
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    completion(false, [])
                } else {
                    records = querySnapshot?.documents.compactMap {
                        try? $0.data(as: Record.self)
                    } ?? []
                    completion(true, records)
                }
        }
    }
    
    func addRecord(record: Record, imageTitle: Data, isImageTitle: Bool, completion: @escaping (Bool, String)->Void) {
        do {
            let result = try db.collection(pathRecords).addDocument(from: record)
        
            if(isImageTitle){
                addImageTitle(idImageTitle: result.documentID, imageTitle: imageTitle){ (verified, status) in
                    if !verified {
                        completion(false, "Ошибка при добавлении записи.")
                    }
                    else{
                        self.updateImageTitle(record, result.documentID)
                        completion(true, result.documentID)
                    }
                }
            }
            else{
                completion(true, result.documentID)
            }
        } catch {
            completion(false, "Ошибка при добавлении записи.")
        }
    }
    
    func updateRecord(record: Record, imageTitle: Data, newImageRecord: Bool, completion: @escaping (Bool, String)->Void) {
        guard let documentId = record.id else { return }
        do {
            try db.collection(pathRecords).document(documentId).setData(from: record)
            if(newImageRecord){
                addImageTitle(idImageTitle: record.id ?? "", imageTitle: imageTitle){ (verified, status) in
                    if !verified {
                        completion(false, "Ошибка при редактировании записи.")
                    }
                    else{
                        self.updateImageTitle(record, record.id ?? "")
                        completion(true, "Запись успешно отредактирована.")
                    }
                }
            }
            else{
                completion(true, "Запись успешно отредактирована.")
            }
        } catch {
            completion(false, "Ошибка при редактировании записи.")
        }
    }
    
    func removeRecord(_ record: Record, completion: @escaping (Bool)->Void){
        guard let documentId = record.id else { return }
        db.collection(pathRecords).document(documentId).delete { error in
            if error != nil {
                completion(false)
            }
            else{
                self.removeImageTitle(documentId){ error in
                    if !error {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
    
    func updateInclusionReport(idRecord: String, idUsersReporting: [String], completion: @escaping (Bool, String)->Void) {
        db.collection(pathRecords).document(idRecord).updateData([
            "idUsersReporting": idUsersReporting
        ]) { error in
            if error != nil {
                completion(false, "Ошибка при обновлении")
            } else {
                completion(true, "Обновлено успешно")
            }
        }
    }
    
    func updateImageTitle(_ record: Record,_ idRecord: String){
        var updateImage = 0
        if(record.updatingImage < 100000){
            updateImage = record.updatingImage + 1
        }
        else{
            updateImage = 0
        }
        db.collection(pathRecords).document(idRecord).updateData([
            "updatingImage": updateImage
        ]) { error in
            if error != nil {
                print("Error")
            }
        }
    }
    
    func addImageTitle(idImageTitle: String, imageTitle: Data, completion: @escaping (Bool, String)->Void) {
        let referenceStorage = storage.reference() // Создаем ссылку на хранилище
        let pathRef = referenceStorage.child(pathImageTitle) // Создаем дочернюю ссылку
    
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        pathRef.child(idImageTitle).putData(imageTitle, metadata: metadata){
            metadata, error in
            guard let metadata = metadata else{
                completion(false, "Ошибка!")
                return
            }
            completion(true, "Успешно!")
        }
    }
    
    func removeImageTitle(_ idImageTitle: String, completion: @escaping (Bool)->Void) {
        let referenceStorage = storage.reference()
        let pathRef = referenceStorage.child(pathImageTitle + "/\(idImageTitle)")

        pathRef.delete { error in
            if error != nil {
                completion(true)
            }
            else{
                completion(true)
            }
        }
    }
    
    func getImageUrl(pathImage: String, idImage: String, completion: @escaping (Bool, URL)->Void) {
        var imageUrl = URL(string: "")
        let storage = storage.reference(withPath: pathImage + "/" + idImage)
           storage.downloadURL { (url, error) in
               if error != nil {
                   completion(false, (URL(string: "https://turbok.by/public/img/no-photo--lg.png"))!)
                   return
               }
               imageUrl = url!
               completion(true, (imageUrl ?? (URL(string: "https://turbok.by/public/img/no-photo--lg.png")))!)
           }
    }
    
    func setSortingRecords(sortingRecordsString: String){
        self.selectedSortingRecords = sortingRecordsString
        sortingRecords(sortingRecords: sortingRecordsString)
    }
    
    func sortingRecords(sortingRecords: String){
        switch sortingRecords {
        case "title":
            self.records.sort(by: { $0.title < $1.title })
        case "authors":
            self.records.sort(by: { $0.authors > $1.authors })
        case "year":
            self.records.sort(by: { $0.year > $1.year })
        case "journalName":
            self.records.sort(by: { $0.journalName > $1.journalName })
        case "universityRecord":
            self.records.sort(by: { $0.universityRecord && !$1.universityRecord })
        default:
            self.records.sort(by: { $0.title > $1.title })
        }
    }
}
