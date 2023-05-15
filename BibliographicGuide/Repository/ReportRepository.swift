//
//  ReportRepository.swift
//  BibliographicGuide
//
//  Created by Alexander on 15.05.23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

let globalReportRepository = ReportRepository()

final class ReportRepository: ObservableObject {
    
    private let pathReport = "Reports"
    private let db = Firestore.firestore()
    @Published var reports: [Report] = []
    
    init(){
        fetchReports()
    }
    
    func fetchReports(){
        db.collection(pathReport).order(by: "titleSaveReport").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.reports = snapshot?.documents.compactMap {
                try? $0.data(as: Report.self)
            } ?? []
        }
    }
    
    func addReport(_ report: Report){
        do {
            _ = try db.collection(pathReport).addDocument(from: report)
        } catch {
            print("Ошибка при сохранении отчета")
        }
    }
    
    func removeReport(_ report: Report){
        guard let documentId = report.id else { return }
        db.collection(pathReport).document(documentId).delete { error in
            if let error = error {
                print("Нe удалось удалить ключевое слово: \(error.localizedDescription)")
            }
        }
    }
}
