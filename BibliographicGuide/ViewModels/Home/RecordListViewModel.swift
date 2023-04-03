//
//  RecordListViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import Combine

final class RecordListViewModel: ObservableObject {
    
    @Published var recordRepository = RecordRepository()
    @Published var recordViewModels: [RecordViewModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        recordRepository.$records
            .map { records in
                records.map(RecordViewModel.init)
            }
            .assign(to: \.recordViewModels, on: self)
            .store(in: &cancellables)
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
