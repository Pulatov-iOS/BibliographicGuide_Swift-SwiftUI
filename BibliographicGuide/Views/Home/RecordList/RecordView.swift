//
//  RecordView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecordView: View {
    
    var recordViewModel: RecordViewModel
    var recordListViewModel: RecordListViewModel
    
    @State private var inclusionReportButton = false
    @State private var inclusionReportAlert = false
    @State private var showRecordPage = false
    var userNameRecord: String
    @State private var imageUrl = URL(string: "")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
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
                    Button(action: {
//                        inclusionReportButton.toggle()
//                        viewModelRecordCard.updateInclusionReport(id: bibliographicRecord.id, inclusionReportButton: inclusionReportButton)
//                        if(inclusionReportButton == true){
//                            inclusionReportAlert.toggle()
//                        }
                    }) {
                        Image(systemName: inclusionReportButton ? "list.clipboard.fill" : "list.clipboard")
                            .font(.system(size:30, weight: .light))
                            .foregroundColor(Color.white)
                            .shadow(color: Color.gray, radius: 2, x: 0, y: 0)
                            .padding(20)
                    }
                    .alert(isPresented: $inclusionReportAlert) {
                        Alert(
                            title: Text("Успешно!"),
                            message: Text("Запись успешно добавлена в список отчета"),
                            dismissButton: .default(Text("Ок")))
                    }
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .top, endPoint: .bottom)
                )
            }

            
            
            VStack(alignment: .leading, spacing: 12) {
                Text(recordViewModel.record.title)
                    .font(.system(.headline, design: .default))
                RecordDescriptionView(recordDescriptionViewModel: RecordDescriptionViewModel(), recordListViewModel: recordListViewModel, recordViewModel: recordViewModel, userNameRecord: userNameRecord)
            }
            .padding()
            .padding(.bottom, 12)
            
        }
        .background(Color("ColorBackgroundAdaptive"))
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
