//
//  MessageListViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import Combine
import Foundation

final class MessageListViewModel: ObservableObject, Equatable {
    
    let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    
    @Published var messageRepository = MessageRepository()
    @Published var messageViewModels: [MessageViewModel] = []
    var сurrentDateMessage = ""
    
    @Published var userInformationRepository = UserInformationRepository()
    @Published var usersInformation: [UserInformation] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        messageRepository.$messages
            .map { message in
                message.map(MessageViewModel.init)
            }
            .assign(to: \.messageViewModels, on: self)
            .store(in: &cancellables)
        
        userInformationRepository.$usersInformation
            .assign(to: \.usersInformation, on: self)
            .store(in: &cancellables)
    }
    
    func addMessage(_ message: Message) {
        messageRepository.addMessage(message)
    }
    
    func updateMessage(_ message: Message) {
        messageRepository.updateMessage(message)
    }
    
    func removeMessage(_ message: Message) {
        messageRepository.removeMessage(message)
    }
    
    func getUserName(_ message: Message) -> String{
        let newUsers = usersInformation.filter { (item) -> Bool in
            item.id! == message.idUser
        }
        return newUsers.first?.userName ?? "User"
    }
    
    func getUserNameResponseMessage(_ replyIdMessage: String) -> String{
        let newMessage = messageViewModels.filter { (item) -> Bool in
            item.id == replyIdMessage
        }
        return getUserName(newMessage.first?.message ?? Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false))
    }
    
    func getTextResponseMessage(_ replyIdMessage: String) -> String{
        let newMessage = messageViewModels.filter { (item) -> Bool in
            item.id == replyIdMessage
        }
        return newMessage.first?.message.text ?? ""
    }
    
    func OutgoingOrIncomingMessage(_ message: Message) -> Bool{
        if(message.idUser == userId){
            return true
        }
        else{
            return false
        }
    }
    
    func MessageToMessageViewModel(_ idMessage: String) -> MessageViewModel{
        let newMessage = messageViewModels.filter { (item) -> Bool in
            item.id == idMessage
        }
        return newMessage.first ?? MessageViewModel(message: Message(idUser: "", typeMessage: "", date: Date(), text: "", idFiles: [""], replyIdMessage: "", editing: false))
    }
    
    func showDateMessage(_ message: Message) -> Bool{
        let newDateMessage = dateMessage(message.date)
        if(newDateMessage == сurrentDateMessage){
            print("\(newDateMessage), \(сurrentDateMessage)")
            return false
        }
        else{
            print("dv\(newDateMessage), \(сurrentDateMessage)")
            сurrentDateMessage = newDateMessage
            return true
        }
    }
    
    func dateMessage(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        // Convert Date to String
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    static func == (lhs: MessageListViewModel, rhs: MessageListViewModel) -> Bool {
        lhs.messageViewModels.count > rhs.messageViewModels.count
    }
}
