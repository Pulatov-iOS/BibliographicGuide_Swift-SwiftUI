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
    
    @State private var showAlertKeyword = false
    @State private var alertTextKeywordTitle: String = ""
    @State private var alertTextKeywordMessage: String = ""

    var body: some View {
        VStack{
            ZStack{
                VStack{
                    if(addKeyword == true){
                        Spacer()
                            .frame(height: 120)
                    }
                    if(addKeyword == false){
                        Spacer()
                            .frame(height: 47)
                    }
                    if(!(isSearching == true && userInformationListViewModel.searchKeywords.count == 0)){
                        List{
                            if(isSearching == true){
                                ForEach(userInformationListViewModel.searchKeywords) { keyword in
                                    KeywordView(keyword: keyword, idSelectedKeyword: $idSelectedKeyword, showAlertKeyword: $showAlertKeyword, alertTextKeywordTitle: $alertTextKeywordTitle, alertTextKeywordMessage: $alertTextKeywordMessage)
                                        .environmentObject(userInformationListViewModel)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            if(idSelectedKeyword == ""){
                                                idSelectedKeyword = keyword.id ?? ""
                                            }
                                            else{
                                                if(keyword.id != idSelectedKeyword){
                                                    idSelectedKeyword = ""
                                                }
                                            }
                                        }
                                }
                            }
                            else{
                                ForEach(userInformationListViewModel.keywords) { keyword in
                                    KeywordView(keyword: keyword, idSelectedKeyword: $idSelectedKeyword, showAlertKeyword: $showAlertKeyword, alertTextKeywordTitle: $alertTextKeywordTitle, alertTextKeywordMessage: $alertTextKeywordMessage)
                                        .environmentObject(userInformationListViewModel)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            if(idSelectedKeyword == ""){
                                                idSelectedKeyword = keyword.id ?? ""
                                            }
                                            else{
                                                if(keyword.id != idSelectedKeyword){
                                                    idSelectedKeyword = ""
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.top, 40)
                    }
                }
                    
                VStack{
                    ZStack{
                        HStack{
                            Text("Ключевые слова".uppercased())
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 25, leading: 0, bottom: 5, trailing: 0))
                        }
                        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
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
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                        }
                    }
                    if(addKeyword == false){
                        SearchBarKeywordView(isSearching: $isSearching)
                            .padding(.bottom, 8)
                            .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                            .environmentObject(userInformationListViewModel)
                    }
                    if(addKeyword == true){
                        VStack{
                            VStack{
                                TextField("Кл. слово", text: $newKeywordName)
                                    .padding(.leading, 7)
                            }
                            .padding(EdgeInsets(top: 10, leading: 6, bottom: 10, trailing: 6))
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            HStack{
                                Button{
                                    addKeyword = false
                                } label: {
                                    Text("Отмена").foregroundColor(.black).frame(width: 100).padding()
                                }
                                .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                                .clipShape(Capsule())
                                Button{
                                    let newKeyword = Keyword(name: newKeywordName)
                                    userInformationListViewModel.addKeyword(newKeyword){
                                        (verified, status) in
                                            if !verified  {
                                                alertTextKeywordTitle = "Не добавлено!"
                                                alertTextKeywordMessage = "Проверьте подключение к сети и повторите попытку"
                                                showAlertKeyword.toggle()
                                            }
                                            else{
                                                alertTextKeywordTitle = "Успешно!"
                                                alertTextKeywordMessage = "Ключевое слово было успешно добавлено"
                                                newKeywordName = ""
                                                showAlertKeyword.toggle()
                                            }
                                    }
                                    addKeyword = false
                                } label: {
                                    Text("Добавить").foregroundColor(.black).frame(width: 100).padding()
                                }
                                .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                                .clipShape(Capsule())
                            }
                            .padding(.top, 4)
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                    }
                    Spacer()
                }
            }
            .alert(isPresented: $showAlertKeyword) {
                Alert(
                    title: Text(alertTextKeywordTitle),
                    message: Text(alertTextKeywordMessage),
                    dismissButton: .default(Text("Ок")))
            }
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
    }
}

//struct KeywordsView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeywordsView()
//    }
//}
