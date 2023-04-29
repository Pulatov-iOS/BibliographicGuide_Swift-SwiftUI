//
//  HomeView.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import SwiftUI

enum SortingRecord: String, CaseIterable, Identifiable {
    case title
    case year
    case authors
    case dateCreation
    case journalName
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .title:
            return "Названию"
        case .year:
            return "Году"
        case .authors:
            return "Автору"
        case .dateCreation:
            return "Дате создания"
        case .journalName:
            return "Журналу"
        }
    }
}

struct RecordListView: View {
    
    @EnvironmentObject var recordListViewModel: RecordListViewModel
    
    @State var showTopFiveRecords = true
    @State var isSearching = false
    @State private var sortingSelectedItem: SortingRecord = .title
    
    var body: some View {
        NavigationView{
            VStack{
                
                SearchBarView(textSearch: "", isSearching: $isSearching)
                    .padding(.vertical, 10)
               
                ScrollView(.vertical, showsIndicators: false) {
                    if(showTopFiveRecords == true){
                        VStack(alignment: .leading) {
                            HStack{
                                Text("По дате редактирования:")
                                    .font(.headline)
                                    .padding(.leading, 15)
                                    .padding(.top, 5)
                                Spacer()
                                Button("скрыть"){
                                    showTopFiveRecords.toggle()
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
                        ZStack{
                            HStack{
                                Text("Все записи")
                                    .fontWeight(.bold)
                                    .font(.system(.title, design: .default))
                                    .foregroundColor(Color.gray)
                                    .padding(8)
                            }
                            HStack{
                                Spacer()
                                VStack{
                                    Picker("Sorting", selection: $sortingSelectedItem){
                                        ForEach(SortingRecord.allCases){ sortingRecord in
                                            Text(sortingRecord.title).tag(sortingRecord)
                                        }
                                    }
                                    .tint(.black)
                                    .onChange(of: sortingSelectedItem){ value in
                                        recordListViewModel.sortingRecords(sortingRecords: sortingSelectedItem.rawValue)
                                    }
                                }
                                .padding(.trailing, 15)
                            }
                        }
                    }
                    else{
                        HStack{
                            Button("Топ 5"){
                                showTopFiveRecords.toggle()
                            }
                            .padding(.leading, 15)
                            Spacer()
                            Button("Сортировка"){
                                showTopFiveRecords.toggle()
                            }
                            .padding(.trailing, 15)
                        }
                    }
                    
                    VStack(alignment: .center, spacing: 20) {
                        if(isSearching == false){
                            ForEach(recordListViewModel.recordViewModels) { records in
                                RecordView(recordViewModel: records, recordListViewModel: recordListViewModel, userNameRecord: recordListViewModel.getUserNameRecord(records.record))
                            }
                        }
                        else{
                            ForEach(recordListViewModel.searchRecordViewModels) { records in
                                RecordView(recordViewModel: records, recordListViewModel: recordListViewModel, userNameRecord: recordListViewModel.getUserNameRecord(records.record))
                            }
                        }
                    }
                    .frame(maxWidth: 640)
                    .padding(.horizontal)
                    .padding(.bottom, 160)
                }
                .edgesIgnoringSafeArea(.all)
                .padding(0)
            }
        }
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
