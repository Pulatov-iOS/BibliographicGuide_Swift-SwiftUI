//
//  HomeView.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import SwiftUI

struct RecordListView: View {
    
    @ObservedObject var recordListViewModel: RecordListViewModel
    @State var topFiveRecord = [RecordViewModel]()
    var body: some View {
        NavigationView{
            VStack{
                
                SearchBarView(textSearch: "", isEditing: false)
                    .padding(.vertical, 10)
               
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("🔥 Топ - по дате редактирования:")
                            .font(.headline)
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 0) {
                                ForEach(topFiveRecord) { records in
                                    TopFiveRecordView(recordListViewModel: recordListViewModel, recordViewModel: records, userNameRecord: recordListViewModel.getUserNameRecord(records.record))
                                }
                            }
                        }
                        .frame(height: 185)
                    }
                    

                    Text("Все записи")
                        .fontWeight(.bold)
                        .font(.system(.title, design: .default))
                        .foregroundColor(Color.gray)
                        .padding(8)
                    
                    VStack(alignment: .center, spacing: 20) {
                        
                        ForEach(recordListViewModel.recordViewModels) { records in
                            RecordView(recordViewModel: records, recordListViewModel: recordListViewModel, userNameRecord: recordListViewModel.getUserNameRecord(records.record))
                        }
                        .onChange(of: recordListViewModel.recordViewModels) { newValue in
                            topFiveRecord = recordListViewModel.getTopFiveRecord()
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
