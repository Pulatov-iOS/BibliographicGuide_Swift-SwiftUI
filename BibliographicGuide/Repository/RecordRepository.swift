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
}
