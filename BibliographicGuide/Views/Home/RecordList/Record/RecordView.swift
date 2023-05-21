//
//  RecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecordView: View {
    
    @Binding var newRecordId: String
    var recordViewModel: RecordViewModel
    var recordListViewModel: RecordListViewModel
    
    @State private var inclusionReportButton = false
    @State private var showAlertInclusionReport = false
    @State private var alertTextEditingTitle: String = "Успешно"
    @State private var alertTextEditingMessage: String = "Запись успешно добавлена в список отчета."
    
    @State private var showRecordPage = false
    var userNameRecord: String
    @State private var imageUrl = URL(string: "")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottom) {
                VStack{
                    WebImage(url: imageUrl)
                        .resizable()
                }
                .frame(height: UIScreen.screenWidth * 0.53)
                .aspectRatio(contentMode: .fit)
                .onAppear{
                    recordListViewModel.getImageUrl(pathImage: "ImageTitle", idImage: recordViewModel.record.id ?? ""){ (verified, status) in
                        if !verified  {
                            imageUrl = status
                        }
                        else{
                            imageUrl = status
                        }
                    }
                }
                .onChange(of: newRecordId){ Value in
                    if(Value == recordViewModel.record.id){
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
                }
                
                HStack {
                    Spacer()
                    VStack{
                        Spacer()
                        HStack(alignment: .bottom){
                            Image(systemName: "person")
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
                                title: Text(alertTextEditingTitle),
                                message: Text(alertTextEditingMessage),
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

            VStack(alignment: .leading, spacing: 8) {
                Text(recordViewModel.record.title)
                    .font(.system(.headline, design: .default))
                    .lineLimit(2)
                    .padding(.trailing, 5)
                    .padding(.leading, 6)
                RecordDescriptionView(recordListViewModel: recordListViewModel, recordViewModel: recordViewModel)
                    .padding(.trailing, 5)
                    .padding(.leading, 6)
            }
            .padding(0)
            .padding([.top, .bottom], 12)
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 0)
        
        .onTapGesture {
            self.showRecordPage = true
        }
        .sheet(isPresented: self.$showRecordPage) {
            RecordPageView(recordListViewModel: recordListViewModel, recordViewModel: recordViewModel, userNameRecord: userNameRecord)
        }
    }
}

//struct RecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordView(recordViewModel: RecordViewModel(record: Record(idUsers: [""], dateCreation: Date(),datesChange: [Date()], title: "", year: 1, keywords: "", authors: "", linkDoi: "", linkWebsite: "", journalName: "", journalNumber: "", pageNumbers: "", description: "", idPhotoTitle: "", idPhotoRecord: "", idPdfRecord: "")))
//    }
//}
