//
//  SecondPageEditingRecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.05.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SecondPageEditingRecordView: View {
    
    @State var recordListViewModel: RecordListViewModel
    @Binding var recordViewModel: RecordViewModel
    @Binding var showEditingWindow: Bool
    
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
    
    @State private var imageRecord = UIImage()
    @State private var newImageRecord = UIImage()
    @State private var defaultImageRecord = false
    @State private var imageUrl = URL(string: "")
    @State private var selectedNewImageRecord = false
    
    @State private var showImagePicker = false
    @State private var showKeywordsWindow = false
    
    @Binding var countKeywordsSelected: Int
    
    @Binding var showAlertEditing: Bool
    @State var showAlertEditingError = false
    @Binding var alertTextEditingTitle: String
    @Binding var alertTextEditingMessage: String
    
    @FocusState private var keyboardIsFocused: Bool
    @Binding var pageCreateRecord: Int
    
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
                                            HStack{
                                                if(defaultImageRecord == true){
                                                    Image(uiImage: self.imageRecord)
                                                        .resizable()
                                                        .cornerRadius(50)
                                                        .frame(width: 60, height: 60)
                                                        .background(Color.black.opacity(0.2))
                                                        .aspectRatio(contentMode: .fill)
                                                        .clipShape(Circle())
                                                        .onTapGesture {
                                                            showImagePicker = true
                                                        }
                                                }
                                                else{
                                                    WebImage(url: imageUrl)
                                                        .resizable()
                                                        .cornerRadius(50)
                                                        .frame(width: 60, height: 60)
                                                        .background(Color.white)
                                                        .aspectRatio(contentMode: .fill)
                                                        .clipShape(Circle())
                                                        .onTapGesture {
                                                            showImagePicker = true
                                                        }
                                                }
                                            }
                                            .onAppear{
                                                recordListViewModel.getImageUrl(pathImage: "ImageTitle", idImage: recordViewModel.record.id ?? ""){ (verified, status) in
                                                    if !verified  {
                                                        defaultImageRecord = true
                                                        imageUrl = status
                                                    }
                                                    else{
                                                        defaultImageRecord = false
                                                        imageUrl = status
                                                    }
                                                }
                                            }
                                            .onChange(of: imageRecord){ Value in
                                                if(newImageRecord != imageRecord){
                                                    defaultImageRecord = true
                                                    newImageRecord = imageRecord
                                                    selectedNewImageRecord = true
                                                }
                                            }
                                            .sheet(isPresented: $showImagePicker) {
                                                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$imageRecord)
                                            }
                                        }
                                        .onAppear(){
                                            imageRecord = UIImage(named: "default-square") ?? UIImage()
                                            newImageRecord = UIImage(named: "default-square") ?? UIImage()
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
                                                KeywordsSelectionEditingView(recordListViewModel: recordListViewModel, countKeywordsSelected: $countKeywordsSelected)
                                                    .frame(width: UIScreen.screenWidth - 80)
                                            }
                                            else{
                                                HStack{
                                                    Spacer()
                                                    Text("Отсутствуют...").foregroundColor(Color(.systemGray3))
                                                        .padding(.top, 23)
                                                    Spacer()
                                                }
                                            }
                                        }
                                        .frame(height: 75)
                                    }
                                }
                            }
                            .scrollDisabled(true)
                            .frame(height: 400)
                            
                            VStack{
                                HStack{
                                    Button(action: {
                                        let imageData = newImageRecord.jpegData(compressionQuality: 0.1)

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
                                            newRecord.description = newDescription
                                            newRecord.universityRecord = newUniversityRecord
                                            newRecord.idKeywords = recordListViewModel.selectedKeywordsId
                                            // изменить данные
                                            recordListViewModel.updateRecord(record: newRecord, ImageTitle: imageData ?? Data(), newImageRecord: selectedNewImageRecord){ (verified, status) in
                                                if !verified {
                                                    alertTextEditingTitle = "Ошибка"
                                                    alertTextEditingMessage = status
                                                    self.showAlertEditing.toggle()
                                                }
                                                else{
                                                    showAlertEditing.toggle()
                                                    showEditingWindow.toggle()
                                                }
                                            }
                                        }
                                        else{
                                            alertTextEditingTitle = "Отказано!"
                                            alertTextEditingMessage = "Отсутствуют права для создания записи."
                                            self.showAlertEditingError.toggle()
                                        }
                                    }) {
                                        HStack {
                                            Text("Сохранить").foregroundColor(.black).padding().frame(width: 160)
                                        }
                                        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                                        .clipShape(Capsule())
                                    }
                                    .alert(isPresented: $showAlertEditingError) {
                                        Alert(
                                            title: Text(alertTextEditingTitle),
                                            message: Text(alertTextEditingMessage),
                                            dismissButton: .default(Text("Ок"))
                                        )
                                    }
                                }
                                .padding(.bottom, 30)
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
                        HStack{
                            Spacer()
                            Text("2 из 2")
                                .padding(.bottom, 5)
                            Spacer()
                        }
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
            EditingKeywordsSelectionSearchView(recordListViewModel: recordListViewModel, countKeywordsSelected: $countKeywordsSelected)
        }
    }
}
