//
//  PdfPreviewView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct PdfPreviewView: View {
    
    @EnvironmentObject var reportViewModel: ReportViewModel
    
    @State private var showShareSheet : Bool = false
    var recordsIncludedReport: [Record]
    
    var newTitleReport: String
    var newCreatorReport: String
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ZStack {
                PdfViewUI(data: reportViewModel.pdfData(recordsIncludedReport: recordsIncludedReport, newTitleReport: newTitleReport, newCreatorReport: newCreatorReport))
                
                VStack{
                    Spacer()
                    
                    Button(action: {
                        self.showShareSheet.toggle()
                    }) {
                        HStack {
                            Text("Поделиться").foregroundColor(.black).padding().frame(width: 160)
                        }
                        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        .clipShape(Capsule())
                    }
                    .padding(.bottom, 25)
                }
            }
            .background(Color(red: 0.949, green: 0.949, blue: 0.971))
            .sheet(isPresented: $showShareSheet, content: {
                if let data = reportViewModel.pdfData(recordsIncludedReport: recordsIncludedReport, newTitleReport: newTitleReport, newCreatorReport: newCreatorReport) {
                    ShareView(activityItems: [data])
                }
            })
        } else {
            Text("Необходима версия iOS 14 и выше")
        }
    }
}

//struct PdfPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        PdfPreviewView()
//    }
//}
