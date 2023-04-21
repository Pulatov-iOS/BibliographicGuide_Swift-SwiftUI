//
//  PdfPreviewView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct PdfPreviewView: View {
    
    var reportViewModel: ReportViewModel
    @State private var showShareSheet : Bool = false
    var recordsIncludedReport: [Record]
    
    var newTitleReport: String
    var newCreatorReport: String
    
    var body: some View {
        if #available(iOS 14.0, *) {
            VStack {
                PdfViewUI(data: reportViewModel.pdfData(recordsIncludedReport: recordsIncludedReport, newTitleReport: newTitleReport, newCreatorReport: newCreatorReport))
                
                Button(action: {
                    self.showShareSheet.toggle()
                }, label: {
                    HStack{
                        Text("Поделиться").foregroundColor(.black).frame(width: 150, height: 30)
                    }
                    .padding(10)
                    .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                    .clipShape(Capsule())
                    .cornerRadius(20)
                    
                })
                .padding(.bottom, 15)
                .padding(.top, 10)
                
                Spacer()
            }.background(Color(red: 0.949, green: 0.949, blue: 0.971))
            .navigationTitle(Text("Отчёт PDF"))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showShareSheet, content: {
                
                if let data = reportViewModel.pdfData(recordsIncludedReport: recordsIncludedReport, newTitleReport: newTitleReport, newCreatorReport: newCreatorReport) {
                    ShareView(activityItems: [data])
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }
}

//struct PdfPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        PdfPreviewView()
//    }
//}
