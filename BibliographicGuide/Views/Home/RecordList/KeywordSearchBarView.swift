//
//  KeywordSearchBarView.swift
//  BibliographicGuide
//
//  Created by Alexander on 30.04.23.
//

import SwiftUI

struct KeywordSearchBarView: View {
    
    @EnvironmentObject var recordListViewModel: RecordListViewModel
    var keyword: Keyword
    
    var body: some View {
        VStack{
            if(recordListViewModel.selectedKeywordsSearch.contains(keyword.id ?? "")){
                VStack{
                    Text(keyword.name)
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                .background(Color.yellow)
                .cornerRadius(10)
                .onTapGesture {
                    recordListViewModel.sortingKeyword(keyword)
                }
            }
            else{
                VStack{
                    Text(keyword.name)
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                .background(Color.white)
                .cornerRadius(10)
                .onTapGesture {
                    recordListViewModel.sortingKeyword(keyword)
                }
            }
        }
        .padding(.leading, 10)
    }
}

//struct KeywordSearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeywordSearchBarView()
//    }
//}
