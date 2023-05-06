//
//  RecordListViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import Combine
import Foundation

final class RecordListViewModel: ObservableObject {
    
    let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    
    @Published var recordRepository = globalRecordRepository
    @Published var recordViewModels: [RecordViewModel] = []
    @Published var searchRecordViewModels: [RecordViewModel] = []
    @Published var topFiveRecords: [RecordViewModel] = []
    
    @Published var userInformationRepository = globalUserInformationRepository
    @Published var usersInformation: [UserInformation] = []
    
    @Published var keywordRepository = globalKeywordRepository
    @Published var keywords: [Keyword] = []
    @Published var selectedKeywordsSearch = [String]()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        recordRepository.$records
            .map { records in
                records.map(RecordViewModel.init)
            }
            .assign(to: \.recordViewModels, on: self)
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
                $0.record.keywords.contains(idKeyword)
            }
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
        for keyword in record.keywords{
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
        return userName.first ?? UserInformation(role: "", userName: "", blockingChat: true, blockingAccount: true)
    }
    
    func checkingEditingTime(_ time: Date) -> String {
        var timeEditing: String
        
//        if(time == nil){   //// если редакт нет!!!!!
//            timeEditing = "отсутствует"
//        }
        
        
        var time = time.millisecondsSince1970
        let nowTime = Date().millisecondsSince1970
        time = nowTime - time
        if(time < 60){
                let seconds = time
                timeEditing = String(seconds) + " сек."
            }
        else{
            if(time > 59 && time < 3600){
                let minutes = (time / 60) % 60
                timeEditing = String(minutes) + " мин."
            }
            else{
                if(time > 3599 && time < 86400){
                    let hours = (time / 3600) % 60
                    timeEditing = String(hours) + " ч."
                }
                else{
                    let day = (time / 86400) % 30
                    timeEditing = String(day) + " дн."
                }
            }

        }
        return timeEditing
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
    
    func updateRecord(record: Record, ImageTitle: Data, completion: @escaping (Bool, String)->Void){
        var newRecord = record
        if(record.description == ""){
            newRecord.description = "Отсутствует"
        }
        newRecord.dateChange = nil
        recordRepository.updateRecord(record: newRecord, imageTitle: ImageTitle){ (verified, status) in
            if !verified {
                completion(false, "Ошибка при запросе редактирования записи.")
            }
            else{
                completion(true, "Запись успешно отредактирована.")
            }
        }
    }
    
    func removeRecord(_ record: Record) {
        recordRepository.removeRecord(record)
    }
    
    func checkInclusionReport(_ record: Record) -> Bool{
        let newRecord = record.idUsersReporting.filter { (item) -> Bool in
            item == userId
        }
        if(newRecord.count > 0){
            return true
        }
        else{
            return false
        }
    }
    
    func updateInclusionReport(record: Record, inclusionReport: Bool, completion: @escaping (Bool, String)->Void){
        var newRecord = record
        if(inclusionReport == true){
            if !newRecord.idUsersReporting.contains(userId){
                newRecord.idUsersReporting.append(userId)
            }
        }
        else{
            if newRecord.idUsersReporting.contains(userId){
                let removed = newRecord.idUsersReporting.remove(at: newRecord.idUsersReporting.firstIndex(of: userId)!)
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
    
    func sortingKeyword(_ keyword: Keyword){
        if(selectedKeywordsSearch.contains(keyword.id ?? "")){
            selectedKeywordsSearch.remove(at: selectedKeywordsSearch.firstIndex(of: keyword.id ?? "") ?? 999999)
        }
        else{
            selectedKeywordsSearch.append(keyword.id ?? "")
        }
        globalKeywordRepository.selectedKeywordsSearch = selectedKeywordsSearch
        globalKeywordRepository.sortingKeywords()
    }
    
    func getImageUrl(pathImage: String, idImage: String, completion: @escaping (Bool, URL)->Void){
        recordRepository.getImageUrl(pathImage: pathImage, idImage: idImage){ (verified, status) in
            if !verified  {
                completion(false, URL(string: "https://turbok.by/public/img/no-photo--lg.png")!)
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
