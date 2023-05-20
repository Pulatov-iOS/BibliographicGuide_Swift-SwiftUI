//
//  EditingKeywordsSelectionSearchView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.05.23.
//

import SwiftUI

struct EditingKeywordsSelectionSearchView: View {
    
    @State var recordListViewModel: RecordListViewModel
    
    @State var textSearch = ""
    @State var isSearching = false
    
    @Binding var countKeywordsSelected: Int
    @State var horizontalKeywords: [[Keyword]] = []
    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    SearchBarEditingView(textSearch: $textSearch, isSearching: $isSearching)
                        .padding(.top, 15)
                    Spacer()
                }
                
                VStack{
                    ScrollView(.vertical, showsIndicators: false, content: {
                        ForEach(0..<horizontalKeywords.count, id: \.self){ id in
                            
                            HStack{
                                ForEach(horizontalKeywords[id]){ keyword in
                                    EditingKeywordSelectionView(recordListViewModel: $recordListViewModel, keyword: keyword, countKeywordsSelected: $countKeywordsSelected)
                                }
                            }
                        }
                    })
                }
                .padding(.top, 65)
            }
        }
        .onAppear(){
            horizontalKeywords = getArrayHorizontalKeywords(recordListViewModel.keywords, CGFloat(20), CGFloat(35))
        }
        .onChange(of: countKeywordsSelected){ value in
            if(textSearch == ""){
                horizontalKeywords = getArrayHorizontalKeywords(recordListViewModel.keywords, CGFloat(20), CGFloat(35))
            }
        }
        .onChange(of: textSearch){ value in
            recordListViewModel.fetchKeywordsSearch(SearchString: textSearch)
            horizontalKeywords = getArrayHorizontalKeywords(recordListViewModel.searchKeywords, CGFloat(20), CGFloat(35))
        }
    }
}
