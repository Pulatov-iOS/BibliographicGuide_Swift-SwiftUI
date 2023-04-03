//
//  RecordListViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import Combine

final class RecordListViewModel: ObservableObject {
    
    @Published var recordRepository = RecordRepository()
    @Published var records: [Record] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        recordRepository.$records
            .assign(to: \.records, on: self)
            .store(in: &cancellables)
    }
    
//    func addRecord(_ record: Record) {
//        recordRepository.addRecord(record)
//    }
}
