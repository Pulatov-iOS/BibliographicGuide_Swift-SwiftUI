//
//  ReportViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import Combine
import Foundation

final class ReportViewModel: ObservableObject {
    
    var userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    
    @Published var recordRepository = globalRecordRepository
    @Published var recordViewModels: [Record] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        recordRepository.$records
            .assign(to: \.recordViewModels, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){
            (_) in
            let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
            self.userId = userId
        }
    }
    
    func getRecordsIncludedReport() -> [Record]{
        let newRecords = recordViewModels.filter { (item) -> Bool in
            item.idUsersReporting.contains(userId)
        }
        return newRecords
    }
    
    func pdfData(recordsIncludedReport: [Record], newTitleReport: String, newCreatorReport: String) -> Data? {
        return PdfCreator().pdfData(recordsIncludedReport: recordsIncludedReport, titleReport: newTitleReport, creatorReport: newCreatorReport)
    }
}
