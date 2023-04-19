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
    
    @Published var recordRepository = RecordRepository()
    @Published var recordViewModels: [RecordViewModel] = []
    
    @Published var userInformationRepository = UserInformationRepository()
    @Published var usersInformation: [UserInformation] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        recordRepository.$records
            .map { records in
                records.map(RecordViewModel.init)
            }
            .assign(to: \.recordViewModels, on: self)
            .store(in: &cancellables)
        
        userInformationRepository.$usersInformation
            .assign(to: \.usersInformation, on: self)
            .store(in: &cancellables)
    }
    
    func getUserNameRecord(_ record: Record) -> String{
        let newUsers = usersInformation.filter { (item) -> Bool in
            item.id! == record.idUsers[0]
        }
        return newUsers.first?.userName ?? "User"
    }
    
    func getСurrentUserInformation() -> UserInformation{
        let userName = usersInformation.filter { (item) -> Bool in
            item.id == userId
        }
        return userName.first ?? UserInformation(role: "", userName: "", blockingChat: true, dateUnblockingChat: Date(), blockingAccount: true)
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
    
    func getTopFiveRecord() -> [RecordViewModel] {
        let sortRecord = recordViewModels.sorted(by: {
            var dateFirst: Date
            var dateSecond: Date
            if($0.record.datesChange.last == nil){
                dateFirst = (Date.now.addingTimeInterval(-500000))
            }
            else {dateFirst = $0.record.datesChange.last!}
            if($1.record.datesChange.last == nil){
                dateSecond = (Date.now.addingTimeInterval(-500000))
            }
            else {dateSecond = $1.record.datesChange.last!}
            return dateFirst > dateSecond
        })
        var topFiveRecord = [RecordViewModel]()
        for item in sortRecord.prefix(5) {
            topFiveRecord.append(item)
        }
        return topFiveRecord
    }

//    func updateRecord(_ record: Record) {
//    }
    
    func removeRecord(_ record: Record) {
        recordRepository.removeRecord(record)
    }
}
