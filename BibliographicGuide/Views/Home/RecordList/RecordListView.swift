//
//  HomeView.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import SwiftUI

enum SortingRecord: String, CaseIterable, Identifiable {
    case title
    case authors
    case year
    case journalName
    case universityRecord
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .title:
            return "Названию"
        case .authors:
            return "Автору"
        case .year:
            return "Году"
        case .journalName:
            return "Журналу"
        case .universityRecord:
            return "Кафедре"
        }
    }
}

struct RecordListView: View {
    
    @EnvironmentObject var recordListViewModel: RecordListViewModel
    
    @State var showTopFiveRecords = true
    @State var textSearch = ""
    @State var isSearching = false
    @State var keywordsSearch = 0
    @State var quantityRecords = 3
    @State var quantityRecordsSearch = 20
    @State private var sortingSelectedItem: SortingRecord = .title
    
    @State private var showAlertRemoveIncludeRecords = false
    @State private var showAlertRemoveIncludeRecordsTitle = ""
    @State private var showAlertRemoveIncludeRecordsMessage = ""
    
    var body: some View {
        VStack{
            
            SearchBarHomeView(textSearch: $textSearch, isSearching: $isSearching)
                .padding(.vertical, 10)
            
            if(isSearching == true){
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(recordListViewModel.keywords) { keyword in
                            KeywordSearchBarView(keywordsSearch: $keywordsSearch, keyword: keyword)
                                .padding(.bottom, 10)
                        }
                    }
                }
                .onChange(of: keywordsSearch){ newValue in
                    recordListViewModel.fetchRecordsSearch(SearchString: textSearch)
                }
            }
           
            ScrollView(.vertical, showsIndicators: false) {
                if(isSearching == false){
                    if(showTopFiveRecords == true){
                        VStack(alignment: .leading) {
                            HStack{
                                HStack(spacing: 0){
                                    Button{
                                        recordListViewModel.removeIncludedRecordsInReport(){ (verified, status) in
                                            if !verified  {
                                                showAlertRemoveIncludeRecordsTitle = "Не обновлено!"
                                                showAlertRemoveIncludeRecordsMessage = "Проверьте подключение к сети и повторите попытку"
                                                showAlertRemoveIncludeRecords.toggle()
                                            }
                                            else{
                                                showAlertRemoveIncludeRecordsTitle = "Успешно"
                                                showAlertRemoveIncludeRecordsMessage = "Все выбранные записи были успешно отменены"
                                                showAlertRemoveIncludeRecords.toggle()
                                            }
                                        }
                                    } label: {
                                        Text(("Выбр. статьи"))
                                        Image(systemName: "trash")
                                    }
                                    .padding(.trailing, 5)
                                    .foregroundColor(.red)
                                    .alert(isPresented: $showAlertRemoveIncludeRecords) {
                                        Alert(
                                            title: Text(showAlertRemoveIncludeRecordsTitle),
                                            message: Text(showAlertRemoveIncludeRecordsMessage),
                                            dismissButton: .default(Text("Ок")))
                                    }
                                }
                                .padding(.leading, 15)
//                                Text("По дате изменения:")
//                                    .font(.headline)
//                                    .padding(.leading, 15)
//                                    .padding(.top, 5)
                                Spacer()
                                HStack(spacing: 0){
                                    Button{
                                        showTopFiveRecords.toggle()
                                    } label: {
                                        Text("Скрыть")
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.trailing, 15)
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 0) {
                                    ForEach(recordListViewModel.topFiveRecords) { records in
                                        TopFiveRecordsView(recordListViewModel: recordListViewModel, recordViewModel: records, userNameRecord: recordListViewModel.getUserNameRecord(records.record))
                                    }
                                }
                            }
                            .frame(height: 185)
                        }
                    }
                    if(showTopFiveRecords == true){
                        HStack{
                            Text("Все записи")
                                .fontWeight(.bold)
                                .font(.system(.title, design: .default))
                                .foregroundColor(Color.black)
                                .padding(0)
                        }
                        HStack{
                            Spacer()
                            VStack{
                                Picker("Sorting", selection: $sortingSelectedItem){
                                    ForEach(SortingRecord.allCases){ sortingRecord in
                                        Text(sortingRecord.title).tag(sortingRecord)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .tint(.black)
                                .onChange(of: sortingSelectedItem){ value in
                                    recordListViewModel.sortingRecords(sortingRecords: sortingSelectedItem.rawValue)
                                }
                            }
                            .padding(.trailing, 15)
                        }
                        .padding(.bottom, 10)
                    }
                    else{
                        HStack{
                            Spacer()
                            HStack(spacing: 0){
                                Button{
                                    showTopFiveRecords.toggle()
                                } label: {
                                    Text("Показать")
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.trailing, 15)
                        }
                    }
                }
                
                VStack(alignment: .center, spacing: 20) {
                    if(isSearching == false){
                        ForEach(recordListViewModel.recordViewModels.prefix(quantityRecords)) { records in
                            RecordView(recordViewModel: records, recordListViewModel: recordListViewModel, userNameRecord: recordListViewModel.getUserNameRecord(records.record))
                        }
                        if(recordListViewModel.recordViewModels.count > quantityRecords){
                            Button{
                                quantityRecords += 1
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.green)
                            }
                            .padding(.bottom, 15)
                        }
                    }
                    else{
                        ForEach(recordListViewModel.searchRecordViewModels.prefix(quantityRecordsSearch)) { records in
                            RecordView(recordViewModel: records, recordListViewModel: recordListViewModel, userNameRecord: recordListViewModel.getUserNameRecord(records.record))
                        }
                        if(recordListViewModel.searchRecordViewModels.count > quantityRecordsSearch){
                            Button{
                                quantityRecordsSearch += 10
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.green)
                            }
                            .padding(.bottom, 15)
                        }
                    }
                }
                .frame(maxWidth: 640)
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .edgesIgnoringSafeArea(.all)
            .padding(0)
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
    }
//    // свайп влево, удаление
//    private func delete(at offsets: IndexSet) {
//        offsets.map { recordListViewModel.recordViewModels[$0].record
//        }.forEach(recordListViewModel.removeRecord)
//    }
}

//struct RecordListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordListView(recordListViewModel: RecordListViewModel())
//    }
//}
