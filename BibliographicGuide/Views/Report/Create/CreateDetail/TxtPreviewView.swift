//
//  TxtPreviewView.swift
//  BibliographicGuide
//
//  Created by Alexander on 26.06.23.
//

import SwiftUI

struct TxtPreviewView: View {
    
    @EnvironmentObject var reportViewModel: ReportViewModel
    
    var recordsIncludedReport: [Record]
    @State var stringRecordsIncludedReport = ""
    
    var body: some View {
        VStack{
            Text("Алфавитный указатель литературы:")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 6)
            VStack{
                TextField("Название", text: $stringRecordsIncludedReport, prompt: Text(""), axis: .vertical)
                    .foregroundColor(.black)
                    .padding([.leading, .trailing, .top], 10)
                    .onAppear(){
                        stringRecordsIncludedReport = reportViewModel.createTxtReport(recordsIncludedReport)
                    }
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(20)
            
            VStack{
                Button(action: {
                    
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
    }
}

//struct TxtPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        TxtPreviewView()
//    }
//}
