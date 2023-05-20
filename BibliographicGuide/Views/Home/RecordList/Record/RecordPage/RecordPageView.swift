//
//  RecordPageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 17.04.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecordPageView: View {
    
    var recordListViewModel: RecordListViewModel
    var recordViewModel: RecordViewModel
    var userNameRecord: String
    @State private var imageUrl = URL(string: "")
    @State private var updateRecordId = ""

    @State private var showEditingRecord: Bool = false
    @Environment(\.presentationMode) var presentationMode // Для закрытия sheet
    
    @State private var inclusionReportButton = false
    @State private var showAlertInclusionReport = false
    @State private var alertTextEditingTitle: String = "Успешно"
    @State private var alertTextEditingMessage: String = "Запись успешно добавлена в список отчета."
    
    @State private var showAlertDelete: Bool = false
    @State private var showAlertDeleteTitle: String = "Удаление записи"
    @State private var showAlertDeleteMessage: String = "Вы действительно хотите удалить данную запись?"
    @State private var showAlertDeleteButton: String = "Да"
    
    @State private var showAlertEditing: Bool = false
    @State private var showAlertEditingTitle: String = "Отказано!"
    @State private var showAlertEditingMessage: String = "У вас отсутствуют права для редактирования записей"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (alignment: .center, spacing: 0) {
                
                ZStack(alignment: .bottom) {
                    VStack{
                        WebImage(url: imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .scaledToFit()
                    .onAppear{
                        recordListViewModel.getImageUrl(pathImage: "ImageTitle", idImage: recordViewModel.record.id ?? ""){ (verified, status) in
                            if !verified  {
                                imageUrl = status
                            }
                            else{
                                print(status)
                                imageUrl = status
                            }
                        }
                    }
    
                    HStack {
                        Spacer()
                        VStack{
                            Spacer()
                            HStack(alignment: .bottom){
                                Image(systemName: "person.2")
                                    .foregroundColor(Color.white)
                                    .font(.callout)
                                    .padding(.leading, 5)
                                
                                Text("\(userNameRecord)")
                                    .foregroundColor(Color.white)
                                    .font(.callout)
                                    .lineLimit(1)
                                Spacer()
                            }
                            
                            HStack{
                                Text("Дата созд: \(recordListViewModel.checkingCreatingTime(recordViewModel.record.dateCreation ?? Date()))")
                                    .foregroundColor(Color.white)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .padding(.leading, 5)
                                Text(" Ред: \(recordListViewModel.checkingEditingTime(recordViewModel.record, withDescription: true))")
                                    .foregroundColor(Color.white)
                                    .font(.caption)
                                    .lineLimit(1)
                                Spacer()
                            }
                            .padding(.bottom, 12)
                        }
                        
                        VStack{
                            Button(action: {
                                recordListViewModel.updateIncludedRecordInReport(record: recordViewModel.record, inclusionReport: !inclusionReportButton){ (verified, status) in
                                    if !verified  {
                                        alertTextEditingTitle = "Ошибка"
                                        alertTextEditingMessage = "Запись не была добавлена в список отчета."
                                    }
                                    else{
                                        alertTextEditingTitle = "Успешно"
                                        alertTextEditingMessage = "Запись успешно добавлена в список отчета."
                                        if(inclusionReportButton == true){
                                            showAlertInclusionReport.toggle()
                                        }
                                    }
                                }
                            }) {
                                Image(systemName: inclusionReportButton ? "list.clipboard.fill" : "list.clipboard")
                                    .font(.system(size:30, weight: .light))
                                    .foregroundColor(Color.white)
                                    .shadow(color: Color.gray, radius: 2, x: 0, y: 0)
                                    .padding(20)
                            }
                            .alert(isPresented: $showAlertInclusionReport) {
                                Alert(
                                    title: Text("Успешно!"),
                                    message: Text("Запись успешно добавлена в список отчета"),
                                    dismissButton: .default(Text("Ок")))
                            }
                            .onAppear(){
                                inclusionReportButton = recordListViewModel.checkInclusionReport(recordViewModel.record.idUsersReporting)
                            }
                            .onChange(of: recordViewModel.record.idUsersReporting){ Value in
                                inclusionReportButton = recordListViewModel.checkInclusionReport(Value)
                            }
                        }
                    }
                    .frame(height: 70)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .top, endPoint: .bottom)
                    )
                }
                
                Group {
                    Text(recordViewModel.record.title.uppercased()) // title
                        .font(.custom("FONT_NAME", size: 18))
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)

                    HStack {
                        Button(action: {
                            let role = recordListViewModel.getСurrentUserInformation().role
                            if(role == "admin" || role == "editor"){
                                showAlertDeleteTitle = "Удаление записи"
                                showAlertDeleteMessage = "Вы действительно хотите удалить данную запись?"
                                showAlertDeleteButton = "Да"
                                showAlertDelete.toggle()
                            }
                            else{
                                showAlertDeleteTitle = "Отказано!"
                                showAlertDeleteMessage = "У вас отсутствуют права для удаления записей"
                                showAlertDeleteButton = "Ок"
                                showAlertDelete.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "xmark.bin")
                                Text("Удалить")
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(40)
                            .shadow(color: Color("ColorBlackTransparentLight"), radius: 5, x: 1, y: 2)
                        }
                        .alert(isPresented: $showAlertDelete){
                            Alert(title: Text(showAlertDeleteTitle), message: Text(showAlertDeleteMessage), primaryButton: .default(Text("Отмена"), action: {
                                // Ничего не делаем
                            }), secondaryButton: .default(Text(showAlertDeleteButton), action: {
                                let role = recordListViewModel.getСurrentUserInformation().role
                                if(role == "admin" || role == "editor"){
                                    recordListViewModel.removeRecord(recordViewModel.record)
                                    presentationMode.wrappedValue.dismiss() // Закрываем окно sheet
                                }
                            }))
                        }
                        Button(action: {
                            let role = recordListViewModel.getСurrentUserInformation().role
                            if(role == "admin" || role == "editor"){
                                self.showEditingRecord = true
                            }
                            else{
                                showAlertEditing.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "pencil.line")
                                Text("Изменить")
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(40)
                            .shadow(color: Color("ColorBlackTransparentLight"), radius: 5, x: 1, y: 2)
                        }
                        .sheet(isPresented: self.$showEditingRecord) {
                            EditingRecordView(recordListViewModel: recordListViewModel, recordViewModel: recordViewModel, newRecordId: $updateRecordId)
                        }
                        .alert(isPresented: $showAlertEditing) {
                            Alert(
                                title: Text(showAlertEditingTitle),
                                message: Text(showAlertEditingMessage),
                                dismissButton: .default(Text("Ок"))
                            )
                        }
                    }
                }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                
                DescriptionRecordPageView(recordViewModel: recordViewModel)
            }
        }
    }
}

//struct RecordPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordPageView()
//    }
//}
