//
//  MessageViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import Combine
import Foundation

final class MessageViewModel: ObservableObject, Identifiable {
    
    @Published var message: Message
    
    var id = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(message: Message){
        self.message = message
        $message
            .compactMap{ $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func dateMessage(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        // Convert Date to String
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    func timeMessage(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        // Convert Date to String
        let newTime = dateFormatter.string(from: date)
        return newTime
    }
}

