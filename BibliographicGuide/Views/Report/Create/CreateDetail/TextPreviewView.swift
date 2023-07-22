//
//  TextPreviewView.swift
//  BibliographicGuide
//
//  Created by Alexander on 26.06.23.
//

import SwiftUI

struct TextPreviewView: View {
    
    @EnvironmentObject var reportViewModel: ReportViewModel
    
    var recordsIncludedReport: [Record]
    var listJournal: Bool
    @State var stringRecordsIncludedReport = ""
    
    @State var showAlertCopyText: Bool = false
    
    var body: some View {
        VStack{
            Text("Библиографический указатель:")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 7)
            VStack{
                TextField("Название", text: $stringRecordsIncludedReport, prompt: Text(""), axis: .vertical)
                    .foregroundColor(.black)
                    .padding([.leading, .trailing, .top], 10)
                    .onAppear(){
                        stringRecordsIncludedReport = reportViewModel.createTextReport(listJournal)
                    }
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(20)
            
            VStack{
                Button(action: {
                    reportViewModel.copyTextClipboard()
                    showAlertCopyText.toggle()
                }) {
                    HStack{
                        Text("Скопировать").foregroundColor(.black).padding().frame(width: 160)
                    }
                    .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                    .clipShape(Capsule())
                }
                .padding(.top, 20)
            }
        }
        .padding(10)
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
        .alert(isPresented: $showAlertCopyText) {
            Alert(
                title: Text("Успешно!"),
                message: Text("Текст скопирован в буфер обмена."),
                dismissButton: .default(Text("Ок"))
            )
        }
    }
}

//struct TextPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextPreviewView()
//    }
//}
