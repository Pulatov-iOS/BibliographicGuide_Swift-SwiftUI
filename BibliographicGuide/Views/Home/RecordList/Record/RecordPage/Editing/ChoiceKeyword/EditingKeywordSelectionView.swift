//
//  EditingKeywordSelectionView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.05.23.
//

import SwiftUI

struct EditingKeywordSelectionView: View {
    
    @Binding var recordListViewModel: RecordListViewModel
    @State var keyword: Keyword
    @Binding var countKeywordsSelected: Int
    
    var body: some View {
        VStack{
            if(recordListViewModel.selectedKeywordsId.contains(keyword.id ?? "")){
                VStack{
                    Text(keyword.name)
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                        .lineLimit(1)
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                .cornerRadius(10)
                .onTapGesture {
                    countKeywordsSelected -= 1
                    recordListViewModel.sortingKeywordEditingSearch(keyword)
                }
            }
            else{
                VStack{
                    Text(keyword.name)
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                        .lineLimit(1)
                }
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 5)
                .background(Color(UIColor.init(hex: "#f2f2f7") ?? .gray))
                .cornerRadius(10)
                .onTapGesture {
                    countKeywordsSelected += 1
                    recordListViewModel.sortingKeywordEditingSearch(keyword)
                }
            }
        }
        .padding(.top, 1)
        .padding(.leading, 4)
        .padding(.bottom, 2)
    }
}

