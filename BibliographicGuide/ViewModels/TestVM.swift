//
//  TestWM.swift
//  BibliographicGuide
//
//  Created by Alexander on 27.04.23.
//

import Foundation

import Combine

let fff = TestVM()

final class TestVM: ObservableObject {
    
    @Published var recordRepository = RecordRepository()
    @Published var recordViewModels: [RecordViewModel] = []
    @Published var topFiveRecords: [RecordViewModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(){
        print("ooo")
        recordRepository.$records
            .map { records in
                records.map(RecordViewModel.init)
            }
            .assign(to: \.recordViewModels, on: self)
            .store(in: &cancellables)
        
        recordRepository.$topFiveRecords
            .map { topFiveRecords in
                topFiveRecords.map(RecordViewModel.init)
            }
            .assign(to: \.topFiveRecords, on: self)
            .store(in: &cancellables)
    }
}
