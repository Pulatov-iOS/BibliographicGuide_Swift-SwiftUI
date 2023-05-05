//
//  CreateViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 18.04.23.
//

import Combine
import Foundation

final class CreateViewModel: ObservableObject {
    
    let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    
    @Published var recordRepository = globalRecordRepository
    
    @Published var userInformationRepository = globalUserInformationRepository
    @Published var usersInformation: [UserInformation] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        userInformationRepository.$usersInformation
            .assign(to: \.usersInformation, on: self)
            .store(in: &cancellables)
    }
    
    func getСurrentUserInformation() -> UserInformation{
        let userName = usersInformation.filter { (item) -> Bool in
            item.id == userId
        }
        return userName.first ?? UserInformation(role: "", userName: "", blockingChat: true, dateUnblockingChat: Date(), blockingAccount: true)
    }
    
    func addRecord(_ record: Record, ImageTitle: Data, completion: @escaping (Bool, String)->Void){
        var newRecord = record
        if(record.description == ""){
            newRecord.description = "Отсутствует"
        }
        newRecord.idUser = userId
        recordRepository.addRecord(record: newRecord, imageTitle: ImageTitle){ (verified, status) in
            if !verified {
                completion(false, "Ошибка при запросе создания записи.")
            }
            else{
                completion(true, "Запись успешно создана.")
            }
        }
    }
}
