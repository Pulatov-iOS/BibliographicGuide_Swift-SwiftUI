//
//  ReportView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct ReportView: View {
    
    @ObservedObject var reportViewModel: ReportViewModel
    @State var newTitleReport = ""
    @State var newCreatorReport = ""
    
    var body: some View {
        NavigationView {
            VStack{
            Text("Создать отчет".uppercased())
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .frame(minWidth: 200)
                .padding(.top, 26)
            NavigationView {
                Form {
                    Section() {
                        HStack {
                            Text("Название отчета:")
                                .foregroundColor(Color.gray)
                            Spacer()
                            TextField("", text: $newTitleReport)
                        }
                        HStack {
                            Text("Создатель:")
                                .foregroundColor(Color.gray)
                            Spacer()
                            TextField("", text: $newCreatorReport)
                        }
                        HStack {
                            Text("Кол-во записей в отчете:")
                                .foregroundColor(Color.gray)
                            Spacer()
                            //   Text(String(viewModelReport.bibliographicRecordInReport.count))
                        }
                        HStack {
                            Text("Формат отчета:")
                                .foregroundColor(Color.gray)
                            Spacer()
                            Text(".pdf")
                        }
                    }
                }
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            HStack{
                Button{
                    clear()
                    hideKeyboard()
                } label:{
                    Text("Очистить").foregroundColor(.black).padding().frame(width: UIScreen.main.bounds.width - 260)
                }.background(Color(red: 0.949, green: 0.949, blue: 0.971))
                    .clipShape(Capsule())
                
                HStack() {
                    NavigationLink(destination : PdfPreviewView(reportViewModel: reportViewModel, recordsIncludedReport: reportViewModel.getRecordsIncludedReport(), newTitleReport: newTitleReport, newCreatorReport: newCreatorReport) ){
                        Text("Создать")
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 230)
                            .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.bottom, 330)
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
    }
    func clear(){
        newTitleReport = ""
        newCreatorReport = ""
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView()
//    }
//}
