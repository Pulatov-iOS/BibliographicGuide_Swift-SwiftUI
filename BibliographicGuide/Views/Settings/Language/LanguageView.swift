//
//  LanguageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 6.07.23.
//

import SwiftUI

struct LanguageView: View {
    
    @Binding var languageSelectedItem: language
    @State var isSearching = false
    @State var textSearch = ""
    
    var body: some View {
        ZStack{
            List {
                if(textSearch != "" && isSearching){
                    ForEach(language.allCases.filter{ (item) -> Bool in item.title.lowercased().contains(textSearch.lowercased()) }){ item in
                        HStack {
                            Text(item.title)
                            Spacer()
                            if(languageSelectedItem.id.rawValue == item.id.rawValue){
                                Image(systemName: "checkmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            languageSelectedItem = item
                        }
                    }
                }
                else{
                    ForEach(language.allCases){ item in
                        HStack {
                            Text(item.title)
                            Spacer()
                            if(languageSelectedItem.id.rawValue == item.id.rawValue){
                                Image(systemName: "checkmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            languageSelectedItem = item
                        }
                    }
                }
            }
            .padding(.top, 82)
            
            VStack(spacing: 0){
                HStack{
                    Text("Язык")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                        .frame(width: UIScreen.screenWidth)
                }
                .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                
                SearchBarLanguageView(textSearch: $textSearch, isSearching: $isSearching)
                    .padding(.top, 7)
                    .padding(.bottom, 5)
                    .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                Spacer()
            }
        }
    }
}

//struct LanguageView_Previews: PreviewProvider {
//    static var previews: some View {
//        LanguageView()
//    }
//}
