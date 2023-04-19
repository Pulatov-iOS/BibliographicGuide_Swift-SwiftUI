//
//  RecordViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import Combine

final class RecordViewModel: ObservableObject, Identifiable, Equatable {
    
    static func == (lhs: RecordViewModel, rhs: RecordViewModel) -> Bool {
        lhs.record.datesChange.hashValue == rhs.record.datesChange.hashValue
    }
    
    private let recordRepository = RecordRepository()
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
