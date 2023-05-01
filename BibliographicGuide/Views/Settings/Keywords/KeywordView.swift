//
//  KeywordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 1.05.23.
//

import SwiftUI

struct KeywordView: View {
    
    @EnvironmentObject var userInformationListViewModel: UserInformationListViewModel
    
    var keyword: Keyword
    @Binding var idSelectedKeyword: String
    @Binding var newKeywordName: String
    
    var body: some View {
        HStack{
            VStack{
                VStack{
                    HStack{
//                        Text(" \(i+1). ")
                        Text(keyword.name)
                        Spacer()
                    }
                    .padding(5)
                }
                .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                .onTapGesture {
                    if(idSelectedKeyword == ""){
                        idSelectedKeyword = keyword.id ?? ""
                    }
                    else{
                        idSelectedKeyword = ""
                    }
                }
                
                if(keyword.id == idSelectedKeyword){
                    HStack{
                        TextField("Кл. слово", text: $newKeywordName)
                            .background(Color.white)
                            .border(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        Spacer()
                        Button("Delete"){
                            userInformationListViewModel.removeKeyword(keyword)
                        }
                        Button("Save"){
                            var updateKeyword = keyword
                            updateKeyword.name = newKeywordName
                            userInformationListViewModel.updateKeyword(updateKeyword)
                        }
                    }
                }
            }

        }
        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765)
        )
        .padding([.leading, .trailing], 10)
    }
}

//struct KeywordView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeywordView()
//    }
//}
