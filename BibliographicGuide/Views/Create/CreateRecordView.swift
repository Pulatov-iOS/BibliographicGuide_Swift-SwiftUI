//
//  CreateRecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 12.05.23.
//

import SwiftUI

struct CreateRecordView: View {
    
    @ObservedObject var createRecordViewModel: CreateRecordViewModel
    
    @State var newTitle = ""
    @State var newAuthors = ""
    @State var newYear = ""
    @State var newJournalName = ""
    @State var newJournalNumber = ""
    @State var newPageNumbers = ""
    @State var newLinkDoi = ""
    @State var newLinkWebsite = ""
    @State var newDescription = ""
    @State var newUniversityRecord = false
    
    @State var showAlertCreate: Bool = false
    @State var alertTextCreateTitle: String = "Отказано"
    @State var alertTextCreateMessage: String = "Отсутствуют права для создания записи."
    
    @State var pageCreateRecord = 1
    
    var body: some View {
        VStack{
            if(pageCreateRecord == 1){
                FirstPageViewCreateRecord(createRecordViewModel: createRecordViewModel, newTitle: $newTitle, newAuthors: $newAuthors, newYear: $newYear, newJournalName: $newJournalName, newJournalNumber: $newJournalNumber, newPageNumbers: $newPageNumbers, newLinkDoi: $newLinkDoi, newLinkWebsite: $newLinkWebsite, showAlertCreate: $showAlertCreate, alertTextCreateTitle: $alertTextCreateTitle, alertTextCreateMessage: $alertTextCreateMessage, pageCreateRecord: $pageCreateRecord)
            }
            else{
                SecondPageCreateRecord(createRecordViewModel: createRecordViewModel, newTitle: $newTitle, newAuthors: $newAuthors, newYear: $newYear, newJournalName: $newJournalName, newJournalNumber: $newJournalNumber, newPageNumbers: $newPageNumbers, newLinkDoi: $newLinkDoi, newLinkWebsite: $newLinkWebsite, newDescription: $newDescription, newUniversityRecord: $newUniversityRecord, showAlertCreate: $showAlertCreate, alertTextCreateTitle: $alertTextCreateTitle, alertTextCreateMessage: $alertTextCreateMessage, pageCreateRecord: $pageCreateRecord)
            }
        }
    }
}

//struct CreateRecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateRecordView()
//    }
//}
