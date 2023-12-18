//
//  ReportView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject var reportViewModel: ReportViewModel
    
    @State private var showCreateReportWindow = false
    @State private var showPdfReportWindow = false
    @State private var showTextReportWindow = false
    @State private var showAlertDelete = false
    
    @State var isSearching = false
    
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    if(reportViewModel.reports.count > 0 && ((isSearching && reportViewModel.searchReports.count > 0) || !isSearching)){
                        List{
                            if(isSearching == false){
                                ForEach(reportViewModel.reports) { report in
                                    ReportDescriptionView(report: report, userNameReport: reportViewModel.getUserNameReport(report))
                                        .environmentObject(reportViewModel)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            reportViewModel.idRecordsToRecords(report.idRecords, titleReport: report.nameCreatedReport, creatorReport: report.authorCreatedReport)
                                            if(report.typeReport == "pdf"){
                                                showPdfReportWindow = true
                                            }
                                            else{
                                                reportViewModel.listJournal = report.listJournal
                                                showTextReportWindow = true
                                            }
                                        }
                                }
                                .onDelete{ indexSet in
                                    let role = reportViewModel.getСurrentUserInformation().role
                                    for index in indexSet{
                                        if(role == "admin" || role == "editor"){
                                            reportViewModel.removeReport(index)
                                        }
                                        else{
                                            showAlertDelete.toggle()
                                        }
                                    }
                                }
                            }
                            else{
                                ForEach(reportViewModel.searchReports) { report in
                                    ReportDescriptionView(report: report, userNameReport: reportViewModel.getUserNameReport(report))
                                        .environmentObject(reportViewModel)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            reportViewModel.idRecordsToRecords(report.idRecords, titleReport: report.nameCreatedReport, creatorReport: report.authorCreatedReport)
                                            if(report.typeReport == "pdf"){
                                                showPdfReportWindow = true
                                            }
                                            else{
                                                reportViewModel.listJournal = report.listJournal
                                                showTextReportWindow = true
                                            }
                                        }
                                }
                                .onDelete{ indexSet in
                                    let role = reportViewModel.getСurrentUserInformation().role
                                    for index in indexSet{
                                        if(role == "admin" || role == "editor"){
                                            reportViewModel.removeReport(index)
                                        }
                                        else{
                                            showAlertDelete.toggle()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 90)
                    }
                    VStack{
                        HStack{
                            Text("Отчеты".uppercased())
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 25, leading: 0, bottom: 5, trailing: 0))
                                .frame(width: UIScreen.screenWidth)
                        }
                        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                        
                        SearchBarReportView(isSearching: $isSearching)
                            .padding(.bottom, 7)
                            .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                        Spacer()
                    }
                }
                .background(Color(red: 0.949, green: 0.949, blue: 0.971))
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button{
                        showCreateReportWindow = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.white)
                            .frame(width: 50, height: 50)
                            .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                            .cornerRadius(50)
                            .padding(30)
                    }
                }
            }
            .alert(isPresented: $showAlertDelete) {
                Alert(
                    title: Text("Отказано!"),
                    message: Text("У вас отсутствуют права для удаления отчетов."),
                    dismissButton: .default(Text("Ок"))
                )
            }
        }
        .sheet(isPresented: self.$showCreateReportWindow) {
            CreateReportView()
                .environmentObject(reportViewModel)
        }
        .sheet(isPresented: self.$showPdfReportWindow) {
            PdfPreviewView(recordsIncludedReport: reportViewModel.recordsInReport, newTitleReport: reportViewModel.titleReport, newCreatorReport: reportViewModel.creatorReport)
                .environmentObject(reportViewModel)
        }
        .sheet(isPresented: self.$showTextReportWindow) {
            TextPreviewView(recordsIncludedReport: reportViewModel.recordsInReport, listJournal: reportViewModel.listJournal)
                .environmentObject(reportViewModel)
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
    }
}
