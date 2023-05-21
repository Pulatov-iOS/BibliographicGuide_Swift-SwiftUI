//
//  SecondPageEditingRecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.05.23.
//

import SwiftUI

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
    
    @State private var imageTitle = UIImage()
    @State private var showImagePicker = false
    @State private var showKeywordsWindow = false
    
    @Binding var countKeywordsSelected: Int
    
    @Binding var showAlertCreate: Bool
    @State var showAlertCreateError = false
    @Binding var alertTextCreateTitle: String
    @Binding var alertTextCreateMessage: String
    
    @Binding var pageCreateRecord: Int
    @Binding var newRecordId: String
    
    var defaultImageTitle = UIImage(named: "default")
    
    var body: some View {
        VStack{
            VStack(spacing: 0){
                ZStack{
                    VStack{
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
                                        .lineLimit(1...3)
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
                                    KeywordsSelectionEditingView(recordListViewModel: recordListViewModel, countKeywordsSelected: $countKeywordsSelected)
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
//                                        alertTextEditingTitle = "Ошибка"
//                                        alertTextEditingMessage = status
//                                        self.showAlertEditing.toggle()
                                    }
                                    else{
                                        showEditingWindow.toggle()
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
                    .padding(.bottom, 40)
                }
            }
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
        .onAppear(){
            imageTitle = UIImage(named: "default") ?? UIImage()
        }
        .sheet(isPresented: self.$showKeywordsWindow) {
            EditingKeywordsSelectionSearchView(recordListViewModel: recordListViewModel, countKeywordsSelected: $countKeywordsSelected)
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
        imageTitle = UIImage(named: "default") ?? UIImage()
        countKeywordsSelected = 0
        recordListViewModel.selectedKeywordsId.removeAll()
    }
}