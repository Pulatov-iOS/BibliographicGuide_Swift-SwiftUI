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
    
    
    func addRecord(_ record: Record) {
        recordRepository.addRecord(record)
    }
    
//    func updateRecord(_ record: Record) {
//    }
    
    func removeRecord(_ record: Record) {
        recordRepository.removeRecord(record)
    }
}
