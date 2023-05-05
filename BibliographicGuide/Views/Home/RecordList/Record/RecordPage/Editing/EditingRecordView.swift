//
//  EditingRecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 19.04.23.
//

import SwiftUI

struct EditingRecordView: View {
    
    var recordListViewModel: RecordListViewModel
    var recordViewModel: RecordViewModel
    var informationDOIApi = InformationDOI()
    
    @State  var newTitle = ""
    @State  var newAuthors = ""
    @State  var newYear = ""
    @State  var newJournalName = ""
    @State  var newJournalNumber = ""
    @State  var newPageNumbers = ""
    @State  var newLinkDoi = ""
    @State  var newLinkWebsite = ""
    @State  var newDescription = ""
    @State  var newKeywords = ""
    
    @Environment(\.presentationMode) var presentationMode // Для закрытия sheet
    
    @State var showAlertLinkDoi: Bool = false
    @State var alertTextLinkDoiTitle: String = "Неверная ссылка DOI"
    @State var alertTextLinkDoiMessage: String = "Проверьте правильность введенной ссылки DOI. Пример: 10.36773/1818-1112-2022-127-1-32-36"
    
    @State var showAlertEditing: Bool = false
    @State var alertTextEditingTitle: String = "Отказано"
    @State var alertTextEditingMessage: String = "Отсутствуют права для создания записи."
    
    var defaultImageTitle = UIImage(named: "default")
    @State var imageTitle = UIImage()
    @State var showImagePicker = false
    @State var statusDefaultImageTitle = false
    
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    Text("Добавить запись".uppercased())
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .frame(minWidth: 200)
                        .padding(.top, 26)
                        .padding(.bottom, 15)
                    Form {
                        Section() {
                            HStack {
                                Text("Название:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                TextField(newTitle, text: $newTitle)
                            }
                            HStack {
                                Text("Ссылка DOI:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                TextField(newLinkDoi, text: $newLinkDoi)
                                Button{
                                    if(newLinkDoi != ""){
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
                                        alertTextLinkDoiTitle = "Введите ссылку DOI!"
                                        alertTextLinkDoiMessage = "Пример ссылки: 10.36773/1818-1112-2022-127-1-32-3"
                                        showAlertLinkDoi.toggle()
                                    }
                                } label:{
                                    Image(systemName: "square.and.arrow.down.on.square")
                                        .foregroundColor(.black)
                                        .padding(2)
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
                            HStack {
                                Text("Авторы:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                if(newAuthors == ""){
                                    TextField("Иванов И. И., Сидоров В. В.", text: $newAuthors)
                                }
                                else{
                                    TextField(newAuthors, text: $newAuthors)
                                }
                            }
                            HStack {
                                Text("Год:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                TextField(newYear, text: $newYear)
                            }
                            HStack {
                                Text("Название журнала:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                TextField(newJournalName, text: $newJournalName)
                            }
                            HStack {
                                Text("Номер журнала:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                TextField(newJournalNumber, text: $newJournalNumber)
                            }
                            HStack {
                                Text("Номер страниц:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                TextField(newPageNumbers, text: $newPageNumbers)
                            }
                            HStack {
                                Text("Ссылка:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                TextField(newLinkWebsite, text: $newLinkWebsite)
                            }
                            HStack {
                                Text("Описание:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                TextField(newDescription, text: $newDescription)
                            }
                            HStack {
                                Text("Изображение:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                HStack {
                                    HStack {
                                        if(statusDefaultImageTitle == true){ // При первой загрузки
                                            Image(uiImage: self.imageTitle)
                                                .resizable()
                                                .cornerRadius(50)
                                                .frame(width: 80, height: 80)
                                                .background(Color.black.opacity(0.2))
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    showImagePicker = true
                                                    statusDefaultImageTitle = true
                                                }
                                        }
                                        else{
                                            Image(uiImage: self.defaultImageTitle!)
                                                .resizable()
                                                .cornerRadius(50)
                                                .frame(width: 80, height: 80)
                                                .background(Color.black.opacity(0.2))
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    showImagePicker = true
                                                    statusDefaultImageTitle = true
                                                }
                                        }
                                    }
                                    .sheet(isPresented: $showImagePicker) {
                                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$imageTitle)
                                    }
                                }
                            }
                        }
                    }.padding(.top, -20)
                    
                    VStack() {
                        // Сохраняем изображение
                        HStack{
                            Button{
                                clean()
                            } label:{
                                Text("Очистить").foregroundColor(.black).padding().frame(width: UIScreen.main.bounds.width - 230)
                            }.background(Color(red: 0.949, green: 0.949, blue: 0.971)) //(red: 0.949, green: 0.949, blue: 0.971)
                                .clipShape(Capsule())
                            
                            Button(action: {
                                let imageData = imageTitle.jpegData(compressionQuality: 0.1)
                                let imageDataDefault = defaultImageTitle?.jpegData(compressionQuality: 0.1)
                                
                                let role = recordListViewModel.getСurrentUserInformation().role
                                if(role == "admin" || role == "editor"){
                                    var newRecord = recordViewModel.record
                                    newRecord.title = newTitle
                                    newRecord.year = Int(newYear) ?? 20000
                                    newRecord.authors = newAuthors
                                    newRecord.journalName = newJournalName
                                    newRecord.journalNumber = newJournalNumber
                                    newRecord.pageNumbers = newPageNumbers
                                    newRecord.description = newDescription
                                    newRecord.linkDoi = newLinkDoi
                                    newRecord.linkWebsite = newLinkWebsite
                                    // изменить данные
                                    recordListViewModel.updateRecord(record: newRecord, ImageTitle: (imageData ?? imageDataDefault)!){ (verified, status) in
                                        if !verified {
                                            alertTextEditingTitle = "Ошибка"
                                            alertTextEditingMessage = status
                                            self.showAlertEditing.toggle()
                                        }
                                        else{
                                            presentationMode.wrappedValue.dismiss() // Закрываем окно sheet
                                        }
                                    }
                                }
                                else{
                                    alertTextEditingTitle = "Отказано"
                                    alertTextEditingMessage = "Отсутствуют права для создания записи."
                                    self.showAlertEditing.toggle()
                                }
                            }) {
                                HStack {
                                    Text("Сохранить").foregroundColor(.black).padding().frame(width: UIScreen.main.bounds.width - 230)
                                }
                                .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                                .clipShape(Capsule())
                            }
                            .alert(isPresented: $showAlertEditing) {
                                Alert(
                                    title: Text(alertTextEditingTitle),
                                    message: Text(alertTextEditingMessage),
                                    dismissButton: .default(Text("Ок"))
                                )
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
                .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                .navigationViewStyle(StackNavigationViewStyle())
            }
            .onAppear(){
                newTitle = recordViewModel.record.title
                newLinkDoi = recordViewModel.record.linkDoi
                newYear = String(recordViewModel.record.year)
                newJournalName = recordViewModel.record.journalName
                newJournalNumber = recordViewModel.record.journalNumber
                newPageNumbers = recordViewModel.record.pageNumbers
                newLinkWebsite = recordViewModel.record.linkWebsite
                newDescription = recordViewModel.record.description
                newAuthors = recordViewModel.record.authors
            }
        }
    }
    
    func clean(){
        newTitle = ""
        newLinkDoi = ""
        newYear = ""
        newJournalName = ""
        newJournalNumber = ""
        newPageNumbers = ""
        newLinkWebsite = ""
        newDescription = ""
        newAuthors = ""
        imageTitle = defaultImageTitle!
    }
}

//struct EditingRecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditingRecordView()
//    }
//}
