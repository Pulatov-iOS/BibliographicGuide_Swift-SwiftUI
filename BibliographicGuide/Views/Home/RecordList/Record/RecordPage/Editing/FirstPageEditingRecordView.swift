//
//  FirstPageEditingRecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.05.23.
//

import SwiftUI

struct FirstPageEditingRecordView: View {
    
    @State var recordListViewModel: RecordListViewModel
    var informationDOIApi = InformationDOI()
    
    @Binding var newTitle: String
    @Binding var newAuthors: String
    @Binding var newYear: String
    @Binding var newJournalName: String
    @Binding var newJournalNumber: String
    @Binding var newPageNumbers: String
    @Binding var newLinkDoi: String
    @Binding var newLinkWebsite: String
    
    @State var showAlertLinkDoi: Bool = false
    @State var alertTextLinkDoiTitle: String = "Неверная ссылка DOI"
    @State var alertTextLinkDoiMessage: String = "Проверьте правильность введенной ссылки DOI. Пример: 10.36773/1818-1112-2022-127-1-32-36"
    
    @Binding var showAlertCreate: Bool
    @Binding var alertTextCreateTitle: String
    @Binding var alertTextCreateMessage: String
    
    @Binding var pageCreateRecord: Int
   
    var body: some View {
        VStack{
            VStack(spacing: 0){
                ZStack{
                    VStack{
                        List{
                            Section(header: Spacer(minLength: 0)) {
                                VStack {
                                    HStack{
                                        Text("Название публикации:")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                    }
                                    TextField("Название", text: $newTitle, prompt: Text("Название..."), axis: .vertical)
                                        .foregroundColor(.black)
                                        .lineLimit(1...3)
                                }
                                VStack {
                                    HStack{
                                        Text("Ссылка DOI:")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                        Image(systemName: "square.and.arrow.down.on.square")
                                            .foregroundColor(.black)
                                            .padding(2)
                                            .onTapGesture {
                                                if(newLinkDoi != ""){
                                                    let role = recordListViewModel.getСurrentUserInformation().role
                                                    if(role == "admin" || role == "editor"){
                                                        informationDOIApi.getObject(doi: newLinkDoi){ (verified, status) in
                                                            if !verified {
                                                                alertTextLinkDoiTitle = "Неверная ссылка DOI!"
                                                                alertTextLinkDoiMessage = "Проверьте правильность введенной ссылки DOI. Пример: 10.36773/1818-1112-2022-127-1-32-36"
                                                                showAlertLinkDoi.toggle()
                                                            }
                                                            else{
                                                                newTitle = informationDOIApi.title
                                                                newAuthors = informationDOIApi.authors
                                                                newYear = informationDOIApi.year
                                                                newJournalName = informationDOIApi.journalName
                                                                newJournalNumber = informationDOIApi.jornalNumber
                                                                newPageNumbers = informationDOIApi.pageNumbers
                                                                newLinkDoi = informationDOIApi.linkDoi
                                                                newLinkWebsite = informationDOIApi.linkWebsite
                                                                alertTextLinkDoiTitle = "Успешно!"
                                                                alertTextLinkDoiMessage = "Данные записи успешно обновлены"
                                                                showAlertLinkDoi.toggle()
                                                            }
                                                        }
                                                    }
                                                    else{
                                                        alertTextLinkDoiTitle = "Отказано!"
                                                        alertTextLinkDoiMessage = "Отсутствуют соответствующие права."
                                                        showAlertLinkDoi.toggle()
                                                    }
                                                }
                                                else{
                                                    alertTextLinkDoiTitle = "Введите ссылку DOI!"
                                                    alertTextLinkDoiMessage = "Пример ссылки: 10.36773/1818-1112-2022-127-1-32-3" //6
                                                    showAlertLinkDoi.toggle()
                                                }
                                            }
                                            .clipShape(Capsule())
                                            .alert(isPresented: $showAlertLinkDoi) {
                                                Alert(
                                                    title: Text(alertTextLinkDoiTitle),
                                                    message: Text(alertTextLinkDoiMessage),
                                                    dismissButton: .default(Text("Ок"))
                                                )
                                            }
                                    }
                                    TextField("10.36773/1818-1112-2022-127-1-32-36", text: $newLinkDoi)
                                }
                                VStack {
                                    HStack{
                                        Text("Авторы:")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                    }
                                    TextField("Иванов И. И., Сидоров В. В.", text: $newAuthors)
                                }
                                HStack {
                                    Text("Год:")
                                        .foregroundColor(Color.gray)
                                    Spacer()
                                    TextField("хххх", text: $newYear)
                                }
                                VStack {
                                    HStack{
                                        Text("Название журнала:")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                    }
                                    TextField("Название...", text: $newJournalName)
                                }
                                HStack {
                                    Text("Номер журнала:")
                                        .foregroundColor(Color.gray)
                                    Spacer()
                                    TextField("ххх", text: $newJournalNumber)
                                }
                                HStack {
                                    Text("Номера страниц:")
                                        .foregroundColor(Color.gray)
                                    Spacer()
                                    TextField("хх-хх", text: $newPageNumbers)
                                }
                                VStack {
                                    HStack{
                                        Text("Ссылка:")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                    }
                                    TextField("https://journal.bstu.by/index.php", text: $newLinkWebsite)
                                }
                            }
                        }
                    }
                    .padding(.top, 80)
                    VStack{
                        Text("Изменить запись".uppercased())
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .frame(minWidth: 200)
                            .padding(EdgeInsets(top: 25, leading: 0, bottom: 10, trailing: 0))
                        Text("1 из 2")
                            .padding(.bottom, 5)
                            .frame(width: UIScreen.screenWidth)
                            .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                        Spacer()
                    }
                    VStack{
                        HStack{
                            HStack(spacing: 0){
                                Spacer()
                                Button("Далее"){
                                    pageCreateRecord = 2
                                }
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(.blue)
                            }
                            .padding(EdgeInsets(top: 75, leading: 0, bottom: 0, trailing: 20))
                        }
                        Spacer()
                    }
                }
            }
            .background(Color(red: 0.949, green: 0.949, blue: 0.971))
            .alert(isPresented: $showAlertCreate) {
                Alert(
                    title: Text(alertTextCreateTitle),
                    message: Text(alertTextCreateMessage),
                    dismissButton: .default(Text("Ок"))
                )
            }
        }
    }
}
