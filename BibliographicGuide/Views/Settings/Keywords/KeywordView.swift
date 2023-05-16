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
    @State private var newKeywordName = ""
    
    @Binding var showAlertKeyword: Bool
    @Binding var alertTextKeywordTitle: String
    @Binding var alertTextKeywordMessage: String
    
    @State private var showAlertDelete: Bool = false
    @State private var showAlertDeleteTitle: String = "Удаление кл. слова"
    @State private var showAlertDeleteMessage: String = "Вы действительно хотите удалить данное ключевое слово?"
    @State private var showAlertDeleteButton: String = "Да"
    
    var body: some View {
        VStack{
            if(idSelectedKeyword != keyword.id){
                HStack{
                    Text(keyword.name)
                    Spacer()
                }
            }
            else{
                VStack{
                    VStack{
                        TextField(keyword.name, text: $newKeywordName)
                    }
                    .padding(.leading, 5)
                    .padding(.top, 2)
                    
                    HStack{
                        HStack{
                            Image(systemName: "xmark.bin")
                            Text("Удалить")
                        }
                        .padding()
                        .foregroundColor(.red)
                        .cornerRadius(40)
                        .onTapGesture {
                            showAlertDelete.toggle()
                        }
                        HStack{
                            Image(systemName: "pencil.line")
                            Text("Изменить")
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        .cornerRadius(40)
                        .onTapGesture {
                            var updateKeyword = keyword
                            updateKeyword.name = newKeywordName
                            userInformationListViewModel.updateKeyword(updateKeyword){
                                (verified, status) in
                                    if !verified  {
                                        alertTextKeywordTitle = "Не обновлено!"
                                        alertTextKeywordMessage = "Проверьте подключение к сети и повторите попытку"
                                        showAlertKeyword.toggle()
                                    }
                                    else{
                                        alertTextKeywordTitle = "Успешно!"
                                        alertTextKeywordMessage = "Ключевое слово было успешно обновлено"
                                        showAlertKeyword.toggle()
                                    }
                            }
                            idSelectedKeyword = ""
                        }
                    }
                    .padding(.top, 8)
                    HStack{
                        Text("")
                        Spacer()
                    }
                    .frame(height: 0)
                }
                .alert(isPresented: $showAlertDelete){
                    Alert(title: Text(showAlertDeleteTitle), message: Text(showAlertDeleteMessage), primaryButton: .default(Text("Отмена"), action: {
                        // Ничего не делаем
                    }), secondaryButton: .default(Text(showAlertDeleteButton), action: {
                        userInformationListViewModel.removeKeyword(keyword)
                    }))
                }
            }
        }
    }
}

//struct KeywordView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeywordView()
//    }
//}
