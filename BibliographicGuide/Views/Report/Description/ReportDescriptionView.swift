//
//  ReportDescriptionView.swift
//  BibliographicGuide
//
//  Created by Alexander on 15.05.23.
//

import SwiftUI

struct ReportDescriptionView: View {
    
    @EnvironmentObject var reportViewModel: ReportViewModel
    var report: Report
    var userNameReport: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(report.titleSaveReport)
                .lineLimit(2)
                .padding(.bottom, 2)
            
            HStack{
                VStack{
                    Image(systemName: "person")
                    Image(systemName: "clock")
                }
                VStack(alignment: .leading){
                    Text("Пользователь: \(userNameReport)")
                        .lineLimit(1)
                    HStack{
                        Text("Дата созд.: \(reportViewModel.checkingCreatingTime(report.date ?? Date()))")
                        Image(systemName: "text.book.closed")
                        Text("Кол-во записей: \(String(report.idRecords.count))")
                    }
                }
            }
            .font(.footnote)
            .foregroundColor(Color.gray)
        }
    }
}

//struct ReportDescriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportDescriptionView()
//    }
//}
