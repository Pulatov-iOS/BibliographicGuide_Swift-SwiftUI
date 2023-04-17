//
//  RecordPageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 17.04.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecordPageView: View {
    
    @State private var inclusionReportButton = false
    @State private var inclusionReportAlert = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (alignment: .center, spacing: 0) {
                
                ZStack(alignment: .bottom) {
                    VStack{
                        WebImage(url: URL(string: "https://www.interfax.ru/ftproot/photos/photostory/2022/04/29/week/week7_1100.jpg"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .scaledToFit()
    
                    HStack {
                        Spacer()
                        Button(action: {
                            inclusionReportButton.toggle()
//                            viewModelDetail.updateInclusionReport(id: bibliographicRecord.id, inclusionReportButton: inclusionReportButton)
                            if(inclusionReportButton == true){
                                inclusionReportAlert.toggle()
                            }
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
            }
        }
    }
}

struct RecordPageView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPageView()
    }
}
