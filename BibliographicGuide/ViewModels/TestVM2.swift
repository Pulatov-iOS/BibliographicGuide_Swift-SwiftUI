//
//  TestVM2.swift
//  BibliographicGuide
//
//  Created by Alexander on 27.04.23.
//

import Foundation
import Combine

final class TestVM2: ObservableObject, Identifiable {
    
    @Published var record: Record
    
    var id = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(record: Record){
        self.record = record
        $record
            .compactMap{ $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
