//
//  KeywordSearchBarView.swift
//  BibliographicGuide
//
//  Created by Alexander on 30.04.23.
//

import SwiftUI

struct KeywordSearchBarView: View {
    
    @EnvironmentObject var recordListViewModel: RecordListViewModel
    @Binding var keywordsSearch: Int
    var keyword: Keyword
    
    var body: some View {
        VStack{
            if(recordListViewModel.selectedKeywordsSearch.contains(keyword.id ?? "")){
                VStack{
                    Text(keyword.name)
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                .cornerRadius(10)
                .onTapGesture {
                    keywordsSearch -= 1
                    recordListViewModel.sortingKeyword(keyword)
                }
            }
            else{
                VStack{
                    Text(keyword.name)
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                .background(Color(UIColor.init(hex: "#f2f2f7") ?? .gray))
                .cornerRadius(10)
                .onTapGesture {
                    keywordsSearch += 1
                    recordListViewModel.sortingKeyword(keyword)
                }
            }
        }
        .padding(.top, 1)
        .padding(.leading, 10)
    }
}

//struct KeywordSearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeywordSearchBarView()
//    }
//}
