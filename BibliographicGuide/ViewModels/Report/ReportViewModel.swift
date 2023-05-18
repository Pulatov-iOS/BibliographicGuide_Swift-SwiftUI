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
    @Published var records: [Record] = []
    
    @Published var recordsInReport: [Record] = []
    @Published var titleReport = ""
    @Published var creatorReport = ""
    
    @Published var reportRepository = globalReportRepository
    @Published var reports: [Report] = []
    
    @Published var userInformationRepository = globalUserInformationRepository
    @Published var usersInformation: [UserInformation] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        reportRepository.$reports
            .assign(to: \.reports, on: self)
            .store(in: &cancellables)
        
        recordRepository.$records
            .assign(to: \.records, on: self)
            .store(in: &cancellables)
        
        userInformationRepository.$usersInformation
            .assign(to: \.usersInformation, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){
            (_) in
            let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
            self.userId = userId
        }
    }
    
    func addReport(titleSaveReport: String, nameCreatedReport: String, authorCreatedReport: String){
        let idRecords = recordsToIdRecords()
        let newReport = Report(idUser: userId, titleSaveReport: titleSaveReport, idRecords: idRecords, date: nil, nameCreatedReport: nameCreatedReport, authorCreatedReport: authorCreatedReport)
        globalReportRepository.addReport(newReport)
    }
    
    func removeReport(_ reportIndex: Int){
        let report = reports[reportIndex]
        globalReportRepository.removeReport(report)
    }
    
    func countRecordsInReport() -> String {
        let newRecord = records.filter { (item) -> Bool in
            item.idUsersReporting.contains(userId)
        }
        return "\(newRecord.count)"
    }
    
    func idRecordsToRecords(_ idRecords: [String], titleReport: String, creatorReport: String){
        self.titleReport = titleReport
        self.creatorReport = creatorReport
        recordsInReport.removeAll()
        for idRecord in idRecords{
            let newRecord = records.filter { (item) -> Bool in
                item.id! == idRecord
            }
            recordsInReport.append(newRecord.first ?? Record(idUser: "", title: "", year: 0, idKeywords: [], authors: "", linkDoi: "", linkWebsite: "", journalName: "", journalNumber: "", pageNumbers: "", description: "", idUsersReporting: [], universityRecord: false))
        }
    }
    
    func recordsToIdRecords() -> [String] {
        var idRecordsInReport: [String] = []
        for record in recordsInReport{
            idRecordsInReport.append(record.id ?? "")
        }
        return idRecordsInReport
    }
    
    func getRecordsIncludedInReport(titleReport: String, creatorReport: String, selectedRecordInReport: Bool, universityRecord: Bool, addSelectedRecord: Bool, yearFromInReport: Int, yearBeforeInReport: Int){
        
        self.titleReport = titleReport
        self.creatorReport = creatorReport
        recordsInReport.removeAll()
        
        // Отчет содержащий только выбранные записи
        if(selectedRecordInReport){
            let newRecords = records.filter { (item) -> Bool in
                item.idUsersReporting.contains(userId)
            }
            recordsInReport = newRecords
        }
        
        // Отчет независимый от выбранных записей
        if(!selectedRecordInReport){
            
            recordsInReport = records
            
            // Только статьи от университета/кафедры
            if(universityRecord){
                let newRecords = recordsInReport.filter { (item) -> Bool in
                    item.universityRecord == true
                }
                recordsInReport = newRecords
            }
            
            // Только статьи определенного года
            if(yearFromInReport != 0 || yearBeforeInReport != 0){
                if(yearFromInReport > 0){
                    let newRecords = recordsInReport.filter { (item) -> Bool in
                        item.year >= yearFromInReport
                    }
                    recordsInReport = newRecords
                }
                if(yearBeforeInReport > 0){
                    let newRecords = recordsInReport.filter { (item) -> Bool in
                        item.year <= yearBeforeInReport
                    }
                    recordsInReport = newRecords
                }
            }
            
            // Добавить выбранные записи в отчет
            if(addSelectedRecord){
                let newRecords = records.filter { (item) -> Bool in
                    item.idUsersReporting.contains(userId)
                }
                for newRecord in newRecords{
                    let includedInReport = recordsInReport.filter { (item) -> Bool in
                        item.id == newRecord.id
                    }
                    if(includedInReport.isEmpty){
                        recordsInReport.append(newRecord)
                    }
                }
            }
        }
    }
    
    func getUserNameReport(_ report: Report) -> String{
        let newUsers = usersInformation.filter { (item) -> Bool in
            item.id! == report.idUser
        }
        return newUsers.first?.userName ?? "User"
    }
    
    func checkingCreatingTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    func checkingYear(yearFromInReport: String, yearBeforeInReport: String) -> Bool {
        if(yearFromInReport == "" && yearBeforeInReport == ""){
            return true
        }
        if(yearFromInReport == "" && ((Int(yearBeforeInReport) ?? 0 > 1900) && (Int(yearBeforeInReport) ?? 0 < 2100))){
            return true
        }
        if(yearBeforeInReport == "" && ((Int(yearFromInReport) ?? 0 > 1900) && (Int(yearFromInReport) ?? 0 < 2100))){
            return true
        }
        if((Int(yearFromInReport) ?? 0 > 1900) && (Int(yearFromInReport) ?? 0 < 2100) && (Int(yearBeforeInReport) ?? 0 > 1900) && (Int(yearBeforeInReport) ?? 0 < 2100)){
            return true
        }
        return false
    }
    
    func pdfData(recordsIncludedReport: [Record], newTitleReport: String, newCreatorReport: String) -> Data? {
        return PdfCreator().pdfData(recordsIncludedReport: recordsIncludedReport, titleReport: newTitleReport, creatorReport: newCreatorReport)
    }
}
