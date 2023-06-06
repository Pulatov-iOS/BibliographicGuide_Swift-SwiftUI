//
//  SecondPageCreateRecord.swift
//  BibliographicGuide
//
//  Created by Alexander on 12.05.23.
//

import SwiftUI

struct SecondPageCreateRecordView: View {
    
    @State var createRecordViewModel: CreateRecordViewModel
    
    @Binding var newTitle: String
    @Binding var newAuthors: String
    @Binding var newYear: String
    @Binding var newJournalName: String
    @Binding var newJournalNumber: String
    @Binding var newPageNumbers: String
    @Binding var newLinkDoi: String
    @Binding var newLinkWebsite: String

    @Binding var newDescription: String
    @Binding var newUniversityRecord: Bool
    
    @Binding var imageTitle: UIImage
    @Binding var imageTitleInformation: UIImage

    @State private var showImagePicker = false
    @State private var showKeywordsWindow = false
    
    @Binding var countKeywordsSelected: Int
    
    @Binding var showAlertCreate: Bool
    @State var showAlertCreateError = false
    @Binding var alertTextCreateTitle: String
    @Binding var alertTextCreateMessage: String
    
    @FocusState private var keyboardIsFocused: Bool
    @Binding var pageCreateRecord: Int
    @Binding var newRecordId: String
    
    var body: some View {
        VStack{
            VStack(spacing: 0){
                ZStack{
                    VStack{
                        ScrollView(.vertical, showsIndicators: false) {
                            List{
                                Section(header: Spacer(minLength: 0)) {
                                    VStack {
                                        HStack{
                                            Text("Описание публикации:")
                                                .foregroundColor(Color.gray)
                                            Spacer()
                                        }
                                        TextField("Отсутствует", text: $newDescription, prompt: Text("Отсутствует..."), axis: .vertical)
                                            .foregroundColor(.black)
                                            .lineLimit(2...2)
                                            .focused($keyboardIsFocused)
                                    }
                                    HStack {
                                        Text("Изображение:")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                        HStack {
                                            HStack {
                                                Image(uiImage: self.imageTitle)
                                                    .resizable()
                                                    .cornerRadius(50)
                                                    .frame(width: 80, height: 80)
                                                    .background(Color.black.opacity(0.2))
                                                    .aspectRatio(contentMode: .fill)
                                                    .clipShape(Circle())
                                                    .onTapGesture {
                                                        showImagePicker = true
                                                    }
                                            }
                                            .sheet(isPresented: $showImagePicker) {
                                                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$imageTitle)
                                            }
                                        }
                                    }
                                    VStack{
                                        ZStack{
                                            HStack{
                                                Text("От университета/кафедры:")
                                                    .foregroundColor(Color.gray)
                                                Spacer()
                                            }
                                            HStack{
                                                Spacer()
                                                Toggle("", isOn: $newUniversityRecord)
                                                    .onTapGesture {
                                                        newUniversityRecord.toggle()
                                                        if(newUniversityRecord == false){
                                                            
                                                        }
                                                        else{
                                                            
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    VStack {
                                        HStack{
                                            HStack{
                                                Text("Ключевые слова:")
                                                    .foregroundColor(Color.gray)
                                                Spacer()
                                            }
                                            Spacer()
                                            Text("Выбрать")
                                                .onTapGesture {
                                                    showKeywordsWindow = true
                                                }
                                                .foregroundColor(.blue)
                                        }
                                        ScrollView(.vertical, showsIndicators: false) {
                                            if(countKeywordsSelected > 0){
                                                KeywordsSelectionCreateView(createRecordViewModel: createRecordViewModel, countKeywordsSelected: $countKeywordsSelected)
                                                    .frame(width: UIScreen.screenWidth - 80)
                                            }
                                            else{
                                                Text("Отсутствуют...").foregroundColor(Color(.systemGray3))
                                                    .frame(width: UIScreen.screenWidth - 80)
                                                    .padding(.top, 23)
                                            }
                                        }
                                        .frame(height: 75)
                                    }
                                }
                            }
                            .scrollDisabled(true)
                            .frame(height: 420)
                            
                            VStack{
                                HStack{
                                    Button{
                                        clean()
                                        pageCreateRecord = 1
                                    } label:{
                                        Text("Очистить").foregroundColor(.black).padding().frame(width: 160)
                                    }.background(Color(red: 0.949, green: 0.949, blue: 0.971))
                                        .clipShape(Capsule())
                                    
                                    Button(action: {
                                        let isImageTitle: Bool
                                        var imageData = Data()
                                        if(imageTitle.cgImage != imageTitleInformation.cgImage){
                                            imageData = imageTitle.jpegData(compressionQuality: 0.1) ?? Data()
                                            isImageTitle = true
                                        }
                                        else{
                                            isImageTitle = false
                                        }

                                        let role = createRecordViewModel.getСurrentUserInformation().role
                                        if(role == "admin" || role == "editor"){
                                            let newRecord = Record(idUser: "", dateCreation: nil, dateChange: nil, title: newTitle, year: Int(newYear) ?? 2000, idKeywords: createRecordViewModel.selectedKeywordsId, authors: newAuthors, linkDoi: newLinkDoi, linkWebsite: newLinkWebsite, journalName: newJournalName, journalNumber: newJournalNumber, pageNumbers: newPageNumbers, description: newDescription, idUsersReporting: [], universityRecord: newUniversityRecord)
                                            createRecordViewModel.addRecord(newRecord, imageTitle: imageData, isImageTitle: isImageTitle){ (verified, status) in
                                                if !verified {
                                                    alertTextCreateTitle = "Ошибка!"
                                                    alertTextCreateMessage = status
                                                    self.showAlertCreateError.toggle()
                                                }
                                                else{
                                                    alertTextCreateTitle = "Успешно!"
                                                    alertTextCreateMessage = "Запись успешно создана."
                                                    clean()
                                                    newRecordId = status
                                                    self.showAlertCreate.toggle()
                                                    pageCreateRecord = 1
                                                }
                                            }
                                        }
                                        else{
                                            alertTextCreateTitle = "Отказано!"
                                            alertTextCreateMessage = "Отсутствуют права для создания записи."
                                            self.showAlertCreateError.toggle()
                                        }
                                    }) {
                                        HStack {
                                            Text("Сохранить").foregroundColor(.black).padding().frame(width: 160)
                                        }
                                        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                                        .clipShape(Capsule())
                                    }
                                    .alert(isPresented: $showAlertCreateError) {
                                        Alert(
                                            title: Text(alertTextCreateTitle),
                                            message: Text(alertTextCreateMessage),
                                            dismissButton: .default(Text("Ок"))
                                        )
                                    }
                                }
                            }
                            .padding(.bottom, 30)
                        }
                    }
                    .padding(.top, 80)
                    VStack{
                        Text("Добавить запись".uppercased())
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .frame(minWidth: 200)
                            .padding(EdgeInsets(top: 25, leading: 0, bottom: 10, trailing: 0))
                        Text("2 из 2")
                            .padding(.bottom, 5)
                            .frame(width: UIScreen.screenWidth)
                            .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                        Spacer()
                    }
                    VStack{
                        HStack{
                            HStack(spacing: 0){
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(.blue)
                                Button("Назад"){
                                    pageCreateRecord = 1
                                }
                            }
                            .padding(EdgeInsets(top: 75, leading: 20, bottom: 0, trailing: 0))
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
            }
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
        .onTapGesture {
            keyboardIsFocused = false // закрытие клавиатуры при нажатии на экран
        }
        .sheet(isPresented: self.$showKeywordsWindow) {
            KeywordsSelectionSearchView(createRecordViewModel: createRecordViewModel, countKeywordsSelected: $countKeywordsSelected)
        }
    }
    
    func clean(){
        newTitle = ""
        newAuthors = ""
        newYear = ""
        newJournalName = ""
        newJournalNumber = ""
        newPageNumbers = ""
        newLinkDoi = ""
        newPageNumbers = ""
        newLinkWebsite = ""
        newDescription = ""
        newUniversityRecord = false
        imageTitle = UIImage(named: "default-square") ?? UIImage()
        countKeywordsSelected = 0
        createRecordViewModel.selectedKeywordsId.removeAll()
        createRecordViewModel.selectedKeywords.removeAll()
    }
}

//struct SecondPageCreateRecord_Previews: PreviewProvider {
//    static var previews: some View {
//        SecondPageCreateRecord()
//    }
//}
