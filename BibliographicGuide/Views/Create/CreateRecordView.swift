//
//  CreateRecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 18.04.23.
//

import SwiftUI

struct CreateRecordView: View {
    
    @ObservedObject var createViewModel: CreateViewModel
    
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
    
    @State  var showAlertLinkDoi: Bool = false
    @State var alertTextLinkDoiTitle: String = "Неверная ссылка DOI"
    @State var alertTextLinkDoiMessage: String = "Проверьте правильность введенной ссылки DOI. Пример: 10.36773/1818-1112-2022-127-1-32-36"
    
    @State  var showAlertCreate: Bool = false
    @State var alertTextCreateTitle: String = "Отказано"
    @State var alertTextCreateMessage: String = "Отсутствуют права для создания записи."
    
     var imageDefault = UIImage(named: "default")
    @State  var image = UIImage()
    @State  var showSheet = false
    @State  var defaultImg = false
    
    var body: some View {
        NavigationView{
            VStack{
                Button("sf"){
                    createViewModel.addRecord(Record(idUsers: ["0y1kzDU4QxMqjxDSeTupTOmWbDl2"], dateCreation: Date(), datesChange: [Date()], title: "Hello", year: 2023, keywords: "key", authors: "Pul", linkDoi: "Doi", linkWebsite: "http", journalName: "jor", journalNumber: "45", pageNumbers: "33", description: "Нет", idPhotoTitle: "", idPhotoRecord: "", idPdfRecord: ""))
                }
                
                VStack{
                    Text("Добавить запись".uppercased())
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .frame(minWidth: 200)
                        .padding(.top, 26)
                    
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
                                    //                            if(newLinkDoi != ""){
                                    //                                doiApi.getObject(doi: newLinkDoi){ result in
                                    //                                    switch result{
                                    //                                    case .success(let res):
                                    //                                        print(res)
                                    //                                        if(res == "ok"){
                                    //                                            newTitle = doiApi.title
                                    //                                            newAuthor = doiApi.author
                                    //                                            newYear = doiApi.year
                                    //                                            newJournalName = doiApi.journalName
                                    //                                            newJournalNumber = doiApi.jornalNumber
                                    //                                            newPageNumber = doiApi.pageNumber
                                    //                                            newLinkDoi = doiApi.linkDoi
                                    //                                            newLink = doiApi.link
                                    //                                            textLinkDoiTitle = "Успешно!"
                                    //                                            textLinkDoiMessage = "Данные записи успешно обновлены"
                                    //                                            showAlertLinkDoi.toggle()
                                    //                                        }
                                    //                                        else{
                                    //                                            textLinkDoiTitle = "Неверная ссылка DOI!"
                                    //                                            textLinkDoiMessage = "Проверьте правильность введенной ссылки DOI. Пример: 10.36773/1818-1112-2022-127-1-32-36"
                                    //                                            showAlertLinkDoi.toggle()
                                    //                                        }
                                    //                                    case .failure(_):
                                    //                                        break
                                    //                                    }
                                    //                                }
                                    //                            }
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
                                        if(defaultImg == true){ // При первой загрузки
                                            Image(uiImage: self.image)
                                                .resizable()
                                                .cornerRadius(50)
                                                .frame(width: 80, height: 80)
                                                .background(Color.black.opacity(0.2))
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    showSheet = true
                                                    defaultImg = true
                                                }
                                        }
                                        else{
                                            //                                    Image(uiImage: self.imageDefault!)
                                            //                                        .resizable()
                                            //                                        .cornerRadius(50)
                                            //                                        .frame(width: 80, height: 80)
                                            //                                        .background(Color.black.opacity(0.2))
                                            //                                        .aspectRatio(contentMode: .fill)
                                            //                                        .clipShape(Circle())
                                            //                                        .onTapGesture {
                                            //                                            showSheet = true
                                            //                                            defaultImg = true
                                            //                                        }
                                        }
                                    }
                                    .sheet(isPresented: $showSheet) {
                                        // Pick an image from the photo library:
                                        //   ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
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
                                //                        if(newDescription == ""){
                                //                            newDescription = "Отсутствует"
                                //                        }
                                //                        let imageData = image.jpegData(compressionQuality: 0.1)
                                //                        let imageDataDefault = imageDefault?.jpegData(compressionQuality: 0.1)
                                //
                                //
                                //                        if(viewModelCreate.userRights.first?.rightCreation == true){
                                //                            viewModelCreate.addBibliographicRecord(idUserCreation: viewModelCreate.userRights.first?.id ?? "", nickname: viewModelCreate.userRights.first?.nickname ?? "",title: newTitle, author: newAuthor, year: newYear, journalName: newJournalName, journalNumber: newJournalNumber, pageNumber: newPageNumber, linkDoi: newLinkDoi, link: newLink, description: newDescription, image: (imageData ?? imageDataDefault)!){ result in
                                //                                switch result{
                                //                                case .success(let id):
                                //                                    print("Save record ok")
                                //                                    idNewRecord = id
                                //
                                //                                case .failure(let error):
                                //                                    print(error.localizedDescription)
                                //                                }
                                //                            }
                                //                            textCreateTitle = "Успешно"
                                //                            textCreateMessage = "Запись успешно создана."
                                //                            clean()
                                //                        }
                                //                        else{
                                //                            textCreateTitle = "Отказано"
                                //                            textCreateMessage = "Отсутствуют права для создания записи."
                                //                        }
                                //                        self.showAlertCreate.toggle()
                                
                            }) {
                                HStack {
                                    Text("Сохранить").foregroundColor(.black).padding().frame(width: UIScreen.main.bounds.width - 230)
                                }
                                .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                                .clipShape(Capsule())
                            }
                            .alert(isPresented: $showAlertCreate) {
                                Alert(
                                    title: Text(alertTextCreateTitle),
                                    message: Text(alertTextCreateMessage),
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
        image = imageDefault!
    }
}

//struct CreateRecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateRecordView()
//    }
//}
