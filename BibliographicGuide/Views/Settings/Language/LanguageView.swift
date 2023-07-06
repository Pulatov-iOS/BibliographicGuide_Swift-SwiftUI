//
//  LanguageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 6.07.23.
//

import SwiftUI

struct LanguageView: View {
    
    @Binding var languageSelectedItem: language
    
    var body: some View {
        ZStack{
            List {
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
            .padding(.top, 25)
            
            VStack{
                HStack{
                    Text("Язык")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                        .frame(width: UIScreen.screenWidth)
                }
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
