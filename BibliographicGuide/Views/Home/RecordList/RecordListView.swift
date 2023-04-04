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

        Text("Все записи")
            .fontWeight(.bold)
            .font(.system(.title, design: .default))
            .foregroundColor(Color.gray)
            .padding(8)
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                
                ForEach(recordListViewModel.recordViewModels) { records in
                    RecordView(recordViewModel: records)
                }
                
            }
            .frame(maxWidth: 640)
            .padding(.horizontal)
            .padding(.bottom, 160)
        }
        .edgesIgnoringSafeArea(.all)
        .padding(0)
        
    }
    
//    // свайп влево, удаление
//    private func delete(at offsets: IndexSet) {
//        offsets.map { recordListViewModel.recordViewModels[$0].record
//        }.forEach(recordListViewModel.removeRecord)
//    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(recordListViewModel: RecordListViewModel())
    }
}
