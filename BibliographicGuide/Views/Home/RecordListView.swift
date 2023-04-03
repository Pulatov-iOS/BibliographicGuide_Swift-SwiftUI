//
//  HomeView.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.04.23.
//

import SwiftUI

struct RecordListView: View {
    
    @ObservedObject var recordListViewModel: RecordListViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(recordListViewModel.recordViewModels) { records in
                        RecordView(recordViewModel: records)
                    }.onDelete(perform: delete)
                }
                .listStyle(InsetListStyle())
                .navigationTitle("Записи")
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.map { recordListViewModel.recordViewModels[$0].record
        }.forEach(recordListViewModel.removeRecord)
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(recordListViewModel: RecordListViewModel())
    }
}
