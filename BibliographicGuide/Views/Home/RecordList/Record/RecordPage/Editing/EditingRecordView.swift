//
//  EditingRecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 19.04.23.
//

import SwiftUI

struct EditingRecordView: View {
    
    @Environment(\.presentationMode) var presentationMode // Для закрытия sheet
    @State var showEditingWindow = true
    @State var recordListViewModel: RecordListViewModel
    @State var recordViewModel: RecordViewModel
    
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
    
    @State var countKeywordsSelected = 0
    
    @State var showAlertEditing: Bool = false
    @State var alertTextEditingTitle: String = "Отказано!"
    @State var alertTextEditingMessage: String = "Отсутствуют права для создания записи."
    
    @State var pageCreateRecord = 1
    
    var body: some View {
        VStack{
            if(pageCreateRecord == 1){
                FirstPageEditingRecordView(recordListViewModel: recordListViewModel, newTitle: $newTitle, newAuthors: $newAuthors, newYear: $newYear, newJournalName: $newJournalName, newJournalNumber: $newJournalNumber, newPageNumbers: $newPageNumbers, newLinkDoi: $newLinkDoi, newLinkWebsite: $newLinkWebsite, pageCreateRecord: $pageCreateRecord)
            }
            else{
                SecondPageEditingRecordView(recordListViewModel: recordListViewModel, recordViewModel: $recordViewModel, showEditingWindow: $showEditingWindow, newTitle: $newTitle, newAuthors: $newAuthors, newYear: $newYear, newJournalName: $newJournalName, newJournalNumber: $newJournalNumber, newPageNumbers: $newPageNumbers, newLinkDoi: $newLinkDoi, newLinkWebsite: $newLinkWebsite, newDescription: $newDescription, newUniversityRecord: $newUniversityRecord, countKeywordsSelected: $countKeywordsSelected, showAlertEditing: $showAlertEditing, alertTextEditingTitle: $alertTextEditingTitle, alertTextEditingMessage: $alertTextEditingMessage, pageCreateRecord: $pageCreateRecord)
            }
        }
        .onAppear(){
            newTitle = recordViewModel.record.title
            newAuthors = recordViewModel.record.authors
            newYear = String(recordViewModel.record.year)
            newJournalName = recordViewModel.record.journalName
            newJournalNumber = recordViewModel.record.journalNumber
            newPageNumbers = recordViewModel.record.pageNumbers
            newLinkDoi = recordViewModel.record.linkDoi
            newLinkWebsite = recordViewModel.record.linkWebsite
            newDescription = recordViewModel.record.description
            newUniversityRecord = recordViewModel.record.universityRecord
            
            countKeywordsSelected = recordViewModel.record.idKeywords.count
            recordListViewModel.selectedKeywordsId.removeAll()
            recordListViewModel.selectedKeywordsId = recordViewModel.record.idKeywords
        }
        .onChange(of: showEditingWindow){ Value in
            presentationMode.wrappedValue.dismiss() // Закрываем окно sheet
        }
    }
}

//struct EditingRecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditingRecordView()
//    }
//}
