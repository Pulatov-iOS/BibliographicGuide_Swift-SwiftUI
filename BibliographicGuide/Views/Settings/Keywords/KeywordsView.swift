//
//  KeywordsView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct KeywordsView: View {
    
    @EnvironmentObject var userInformationListViewModel: UserInformationListViewModel
    
    @State var idSelectedKeyword = ""
    @State var addKeyword = false
    @State var newKeywordName = ""
    @State var isSearching = false

    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    VStack{
                        Text("Ключевые слова".uppercased())
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .frame(minWidth: 200)
                            .padding(.top, 26)
                            .padding(.bottom, 15)
                    }
                    HStack{
                        Spacer()
                        Button{
                           addKeyword = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.green)
                        }
                        .padding(20)
                    }
                }
                
              //  SearchBarView(textSearch: "", isSearching: $isSearching)
                
                if(addKeyword == true){
                    HStack{
                        TextField("Кл. слово", text: $newKeywordName)
                        Spacer()
                        Button("Cancel"){
                            addKeyword = false
                        }
                        Button("Add"){
                            let newKeyword = Keyword(name: newKeywordName)
                            userInformationListViewModel.addKeyword(newKeyword)
                            addKeyword = false
                        }
                    }
                    .padding(10)
                }

                ScrollView(.vertical, showsIndicators: false){
                    ForEach(userInformationListViewModel.keywords) {keyword in
                        KeywordView(keyword: keyword, idSelectedKeyword: $idSelectedKeyword, newKeywordName: $newKeywordName)
                    }
                }
                Spacer()
                    
            }
        }
    }
}

struct KeywordsView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordsView()
    }
}
