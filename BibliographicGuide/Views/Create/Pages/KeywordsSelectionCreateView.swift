//
//  KeywordsSelectionCreateView.swift
//  BibliographicGuide
//
//  Created by Alexander on 12.05.23.
//

import SwiftUI

struct KeywordsSelectionCreateView: View {
    
    @State var createRecordViewModel: CreateRecordViewModel
    
    @Binding var countKeywordsSelected: Int
    @State var horizontalKeywords: [[Keyword]] = []
    
    var body: some View {
        VStack{
            VStack{
                ForEach(0..<horizontalKeywords.count, id: \.self){ id in
                    HStack{
                        ForEach(horizontalKeywords[id]){ keyword in
                            KeywordSelectionView(createRecordViewModel: $createRecordViewModel, keyword: keyword, countKeywordsSelected: $countKeywordsSelected)
                        }
                    }
                }
            }
        }
        .onAppear(){
            createRecordViewModel.keywordsIdToKeywords()
            horizontalKeywords = getArrayHorizontalKeywords(createRecordViewModel.selectedKeywords, CGFloat(40), CGFloat(55))
        }
        .onChange(of: countKeywordsSelected){ value in
            createRecordViewModel.keywordsIdToKeywords()
            horizontalKeywords = getArrayHorizontalKeywords(createRecordViewModel.selectedKeywords, CGFloat(40), CGFloat(55))
        }
    }
}
