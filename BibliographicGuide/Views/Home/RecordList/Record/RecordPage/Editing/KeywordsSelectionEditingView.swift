//
//  KeywordsSelectionEditingView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.05.23.
//

import SwiftUI

struct KeywordsSelectionEditingView: View {
    
    @State var recordListViewModel: RecordListViewModel
    
    @Binding var countKeywordsSelected: Int
    @State var horizontalKeywords: [[Keyword]] = []
    
    var body: some View {
        VStack{
            VStack{
                ForEach(0..<horizontalKeywords.count, id: \.self){ id in
                    HStack{
                        ForEach(horizontalKeywords[id]){ keyword in
                            EditingKeywordSelectionView(recordListViewModel: $recordListViewModel, keyword: keyword, countKeywordsSelected: $countKeywordsSelected)
                        }
                    }
                }
            }
        }
        .onAppear(){
            recordListViewModel.keywordsIdToKeywords()
            horizontalKeywords = getArrayHorizontalKeywords(recordListViewModel.selectedKeywords, CGFloat(40), CGFloat(55))
        }
        .onChange(of: countKeywordsSelected){ value in
            recordListViewModel.keywordsIdToKeywords()
            horizontalKeywords = getArrayHorizontalKeywords(recordListViewModel.selectedKeywords, CGFloat(40), CGFloat(55))
        }
    }
}

//struct KeywordsSelectionEditingView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeywordsSelectionEditingView()
//    }
//}
