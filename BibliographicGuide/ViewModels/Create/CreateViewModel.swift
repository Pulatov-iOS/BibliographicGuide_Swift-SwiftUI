//
//  CreateViewModel.swift
//  BibliographicGuide
//
//  Created by Alexander on 18.04.23.
//

import Foundation

final class CreateViewModel: ObservableObject {
    
    @Published var recordRepository = RecordRepository()
    
    func addRecord(_ record: Record) {
        recordRepository.addRecord(record)
    }
}
