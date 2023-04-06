//
//  MessageListViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import Combine

final class MessageListViewModel: ObservableObject {
    
    @Published var messageRepository = MessageRepository()
    @Published var messageViewModels: [MessageViewModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var userInformationRepository = UserInformationRepository()
    @Published var usersInformation: [UserInformation] = []
    
    private var cancellables2: Set<AnyCancellable> = []
    
    init(){
        messageRepository.$messages
            .map { message in
                message.map(MessageViewModel.init)
            }
            .assign(to: \.messageViewModels, on: self)
            .store(in: &cancellables)
        
        userInformationRepository.$usersInformation
            .assign(to: \.usersInformation, on: self)
            .store(in: &cancellables2)
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
        print(usersInformation.count)
        print(usersInformation.last?.userName)
        let newUsers = usersInformation.filter { (item) -> Bool in
            item.id! == message.idUser
        }
        return newUsers.first?.userName ?? "User"
    }
}
