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
    
    init(){
        messageRepository.$messages
            .map { message in
                message.map(MessageViewModel.init)
            }
            .assign(to: \.messageViewModels, on: self)
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
}
