//
//  RecordListViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import Combine
import Foundation

final class RecordListViewModel: ObservableObject {
    
    var userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    
    @Published var recordRepository = globalRecordRepository
    @Published var recordViewModels: [RecordViewModel] = []
    @Published var searchRecordViewModels: [RecordViewModel] = []
    @Published var topFiveRecords: [RecordViewModel] = []
    @Published var recordsInReport: [Record] = []
    @Published var searchRecords: [Record] = []
    
    @Published var userInformationRepository = globalUserInformationRepository
    @Published var usersInformation: [UserInformation] = []
    
    @Published var keywordRepository = globalKeywordRepository
    @Published var keywords: [Keyword] = []
    @Published var selectedKeywordsSearch = [String]() // Главный поиск
    @Published var selectedKeywordsId: [String] = [] // Редактирование
    @Published var selectedKeywords: [Keyword] = [] // Редактирование
    @Published var searchKeywords: [Keyword] = [] // Редактирование
    
    private var reportRepository = globalReportRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        recordRepository.$records
            .map { records in
                records.map(RecordViewModel.init)
            }
            .assign(to: \.recordViewModels, on: self)
            .store(in: &cancellables)
        
        recordRepository.$records
            .assign(to: \.searchRecords, on: self)
            .store(in: &cancellables)
        
        recordRepository.$topFiveRecords
            .map { topFiveRecords in
                topFiveRecords.map(RecordViewModel.init)
            }
            .assign(to: \.topFiveRecords, on: self)
            .store(in: &cancellables)
        
        keywordRepository.$keywords
            .assign(to: \.keywords, on: self)
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
    
    func fetchRecordsSearch(SearchString: String){
        if(SearchString != ""){
            searchRecordViewModels = recordViewModels.filter{ $0.record.title.lowercased().contains(SearchString.lowercased()) ||
                $0.record.authors.lowercased().contains(SearchString.lowercased()) ||
                $0.record.journalName.lowercased().contains(SearchString.lowercased()) ||
                String($0.record.year).lowercased().contains(SearchString.lowercased())
            }
        }
        else{
            if(selectedKeywordsSearch.count > 0){
                searchRecordViewModels = recordViewModels
            }
            else{
                searchRecordViewModels = [RecordViewModel]() // Очищаем список записей при отмене выбора кл. слов
            }
        }
        for idKeyword in selectedKeywordsSearch{ // Поиск записей по кл. словам
            searchRecordViewModels = searchRecordViewModels.filter{
                $0.record.idKeywords.contains(idKeyword)
            }
        }
    }
    
    func fetchKeywordsSearch(SearchString: String){
        if(SearchString != ""){
            searchKeywords = keywords.filter{ $0.name.lowercased().contains(SearchString.lowercased())
            }
        }
        else{
            searchKeywords = keywords
        }
    }
    
    func sortingRecords(sortingRecords: String){
        globalRecordRepository.setSortingRecords(sortingRecordsString: sortingRecords)
    }

    func getUserNameRecord(_ record: Record) -> String{
        let newUsers = usersInformation.filter { (item) -> Bool in
            item.id! == record.idUser
        }
        return newUsers.first?.userName ?? "User"
    }
    
    func getKeywordNameRecord(_ record: Record) -> String{
        var keywordsArray = ""
        for keyword in record.idKeywords{
            if(keywordsArray != ""){
                keywordsArray = keywordsArray + ", "
            }
            let newKeyword = keywords.filter { (item) -> Bool in
                item.id! == keyword
            }
            keywordsArray = keywordsArray + (newKeyword.first?.name ?? "")
        }
        return keywordsArray
    }
    
    func getСurrentUserInformation() -> UserInformation{
        let userName = usersInformation.filter { (item) -> Bool in
            item.id == userId
        }
        return userName.first ?? UserInformation(role: "", userName: "", blockingChat: true, blockingAccount: true, reasonBlockingAccount: "")
    }
    
    func checkingEditingTime(_ record: Record, withDescription: Bool) -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(record.dateChange ?? Date()))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        if(withDescription){
            if(record.dateChange != record.dateCreation){
                if secondsAgo < minute {
                    return "\(secondsAgo) сек. назад"
                } else if secondsAgo < hour {
                    return "\(secondsAgo / minute) мин. назад"
                } else if secondsAgo < day {
                    return "\(secondsAgo / hour) ч. назад"
                } else if secondsAgo < week {
                    return "\(secondsAgo / day) дн. назад"
                } else if secondsAgo < month {
                    return "\(secondsAgo / week) нед. назад"
                } else if secondsAgo < year {
                    return "\(secondsAgo / month) мес. назад"
                }
                
                if((secondsAgo / year) > 1){
                    if((secondsAgo / year) > 4){
                        return "\(secondsAgo / year) лет назад"
                    }
                    else{
                        return "\(secondsAgo / year) года назад"
                    }
                }
                else{
                    return "\(secondsAgo / year) год назад"
                }
            }
            else{
                return "отсутствует"
            }
        }
        else{
            if secondsAgo < minute {
                return "\(secondsAgo) сек."
            } else if secondsAgo < hour {
                return "\(secondsAgo / minute) мин."
            } else if secondsAgo < day {
                return "\(secondsAgo / hour) ч."
            } else if secondsAgo < week {
                return "\(secondsAgo / day) дн."
            } else if secondsAgo < month {
                return "\(secondsAgo / week) нед."
            } else if secondsAgo < year {
                return "\(secondsAgo / month) мес."
            }
            
            if((secondsAgo / year) > 1){
                if((secondsAgo / year) > 4){
                    return "\(secondsAgo / year) лет"
                }
                else{
                    return "\(secondsAgo / year) года"
                }
            }
            else{
                return "\(secondsAgo / year) год"
            }
        }
    }
    
    func checkingCreatingTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        // Convert Date to String
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    func universityRecordToString(_ universityRecord: Bool) -> String{
        if(universityRecord == true){
            return "Да"
        }
        else{
            return "Нет"
        }
    }
    
    func updateRecord(record: Record, ImageTitle: Data, newImageRecord: Bool, completion: @escaping (Bool, String)->Void){
        var newRecord = record
        if(record.description == ""){
            newRecord.description = "Отсутствует"
        }
        newRecord.dateChange = nil
        if(newRecord.updatingImage > 100000){
            newRecord.updatingImage = 0
        }
        else{
            newRecord.updatingImage += 1
        }
        recordRepository.updateRecord(record: newRecord, imageTitle: ImageTitle, newImageRecord: newImageRecord){ (verified, status) in
            if !verified {
                completion(false, "Ошибка при запросе редактирования записи.")
            }
            else{
                self.selectedKeywordsId.removeAll()
                globalKeywordRepository.selectedKeywordsSearch.removeAll()
                globalKeywordRepository.sortingNameKeywords()
                completion(true, "Запись успешно отредактирована.")
            }
        }
    }
    
    func removeRecord(_ record: Record, completion: @escaping (Bool)->Void) {
        var reportsWithCurrentRecord: [Report] = []
        reportRepository.getReportsWithCurrentRecord(record){ (error, reports) in
            if !error {
                completion(false)
            }
            else{
                reportsWithCurrentRecord = reports
                self.recordRepository.removeRecord(record){ error in
                    if !error {
                        completion(false)
                    }
                    else {
                        for report in reportsWithCurrentRecord{
                            var newReport = report
                            var newIdRecords = newReport.idRecords
                            if newIdRecords.contains(record.id ?? " "){
                                newIdRecords.remove(at: newIdRecords.firstIndex(of: record.id ?? "") ?? 99999999)
                            }
                            newReport.idRecords = newIdRecords
                            self.reportRepository.updateReport(newReport)
                        }
                        completion(true)
                    }
                }
            }
        }
    }
    
    func checkInclusionReport(_ idUsersReporting: [String]) -> Bool {
        let newRecord = idUsersReporting.filter { (item) -> Bool in
            item == userId
        }
        if(newRecord.count > 0){
            return true
        }
        else{
            return false
        }
    }
    
    func getRecordsIncludedInReport(){
        recordsInReport.removeAll()
        var records: [Record] = []
        for recordViewModel in recordViewModels{
            records.append(recordViewModel.record)
        }
        let newRecords = records.filter { (item) -> Bool in
            item.idUsersReporting.contains(userId)
        }
        recordsInReport = newRecords
    }
    
    func updateIncludedRecordInReport(record: Record, inclusionReport: Bool, completion: @escaping (Bool, String)->Void) {
        var newRecord = record
        if(inclusionReport == true){
            if !newRecord.idUsersReporting.contains(userId){
                newRecord.idUsersReporting.append(userId)
            }
        }
        else{
            if newRecord.idUsersReporting.contains(userId){
                newRecord.idUsersReporting.remove(at: newRecord.idUsersReporting.firstIndex(of: userId)!)
            }
        }
        
        recordRepository.updateInclusionReport(idRecord: record.id ?? "", idUsersReporting: newRecord.idUsersReporting){ (verified, status) in
            if !verified  {
                completion(false, "Ошибка при обновлении")
            }
            else{
                completion(true, "Обновлено успешно")
            }
        }
    }
    
    func removeIncludedRecordsInReport(completion: @escaping (Bool, String)->Void) {
        getRecordsIncludedInReport()
        for recordInReport in recordsInReport{
            var newRecordsInReport = recordInReport.idUsersReporting
            newRecordsInReport.remove(at: newRecordsInReport.firstIndex(of: userId)!)
            
            recordRepository.updateInclusionReport(idRecord: recordInReport.id ?? "", idUsersReporting: newRecordsInReport){ (verified, status) in
                if !verified  {
                    completion(false, "")
                }
                else{
                    completion(true, "")
                }
            }
        }
    }
    
    func keywordsIdToKeywords(){
        selectedKeywords.removeAll()
        for keyword in selectedKeywordsId {
            selectedKeywords.append(keywords.first(where: { $0.id == keyword }) ?? Keyword(name: ""))
        }
    }
    
    func sortingKeywordSearch(_ keyword: Keyword){ // главный поиск
        if(selectedKeywordsSearch.contains(keyword.id ?? "")){
            selectedKeywordsSearch.remove(at: selectedKeywordsSearch.firstIndex(of: keyword.id ?? "") ?? 999999)
        }
        else{
            selectedKeywordsSearch.append(keyword.id ?? "")
        }
        globalKeywordRepository.selectedKeywordsSearch = selectedKeywordsSearch
        globalKeywordRepository.sortingKeywords()
    }
    
    func sortingKeywordEditingSearch(_ keyword: Keyword){
        if(selectedKeywordsId.contains(keyword.id ?? "")){
            selectedKeywordsId.remove(at: selectedKeywordsId.firstIndex(of: keyword.id ?? "") ?? 999999)
        }
        else{
            selectedKeywordsId.append(keyword.id ?? "")
        }
        globalKeywordRepository.selectedKeywordsSearch = selectedKeywordsId
        globalKeywordRepository.sortingKeywords()
    }
    
    func getImageUrl(pathImage: String, idImage: String, completion: @escaping (Bool, URL)->Void){
        recordRepository.getImageUrl(pathImage: pathImage, idImage: idImage){ (verified, status) in
            if !verified  {
                completion(false, URL(string: "https://firebase.google.com/")!)
            }
            else{
                completion(true, status)
            }
        }
    }
}

extension Date{
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
