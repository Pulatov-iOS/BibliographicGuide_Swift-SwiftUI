//
//  CreateReportView.swift
//  BibliographicGuide
//
//  Created by Alexander on 13.05.23.
//

import SwiftUI
import Combine

struct CreateReportView: View {
    
    @EnvironmentObject var reportViewModel: ReportViewModel
    
    @State private var newTitleReport = ""
    @State private var newCreatorReport = ""
    @State private var selectedRecordInReport = true
    @State private var universityRecord = false
    @State private var addSelectedRecord = false
    
    @State private var yearFromInReport = ""
    @State private var yearBeforeInReport = ""
    
    @State private var saveReport = false
    @State private var newTitleSaveReport = ""
    
    @State var showAlertCreateError: Bool = false
    @State var alertTextCreateTitleError: String = ""
    @State var alertTextCreateMessageError: String = ""
    
    @State private var showPdfReportWindow = false
    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    List{
                        Section(header: Spacer(minLength: 0)) {
                            HStack {
                                VStack{
                                    HStack{
                                        Text("Название отчета:")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                    }
                                    TextField("Название", text: $newTitleReport, prompt: Text("Название..."), axis: .vertical)
                                        .foregroundColor(.black)
                                        .lineLimit(1...3)
                                }
                            }
                            HStack {
                                Text("Создатель:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                TextField("Иванов А. А.", text: $newCreatorReport)
                            }
                            HStack {
                                Text("Формат отчета:")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                Text(".pdf")
                            }
                            VStack{
                                ZStack{
                                    HStack{
                                        Text("Только выбранные записи:")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                    }
                                    HStack{
                                        Spacer()
                                        Toggle("", isOn: $selectedRecordInReport)
                                    }
                                }
                            }
                            if(selectedRecordInReport == false){
                                VStack{
                                    ZStack{
                                        HStack{
                                            Text("От университета/кафедры:")
                                                .foregroundColor(Color.gray)
                                            Spacer()
                                        }
                                        HStack{
                                            Spacer()
                                            Toggle("", isOn: $universityRecord)
                                        }
                                    }
                                }
                                HStack{
                                    Text("Год публикаций:")
                                        .foregroundColor(Color.gray)
                                    Spacer()
                                    TextField("2020", text: $yearFromInReport)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(yearFromInReport)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.yearFromInReport = filtered
                                            }
                                            if(newValue.count > 4){
                                                self.yearFromInReport = String(filtered.prefix(4))
                                            }
                                        }
                                        .frame(width: 42)
                                    Text("-")
                                        .foregroundColor(Color.gray)
                                    TextField("2023", text: $yearBeforeInReport)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(yearBeforeInReport)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.yearBeforeInReport = filtered
                                            }
                                            if(newValue.count > 4){
                                                self.yearBeforeInReport = String(filtered.prefix(4))
                                            }
                                        }
                                        .frame(width: 42)
                                }
                                VStack{
                                    ZStack{
                                        HStack{
                                            Text("Добавить выбранные записи:")
                                                .foregroundColor(Color.gray)
                                            Spacer()
                                        }
                                        HStack{
                                            Spacer()
                                            Toggle("", isOn: $addSelectedRecord)
                                        }
                                    }
                                }
                            }
                            if(selectedRecordInReport || addSelectedRecord){
                                HStack {
                                    Text("Кол-во выбранных записей:")
                                        .foregroundColor(Color.gray)
                                    Spacer()
                                    Text(String(reportViewModel.countRecordsInReport()))
                                }
                            }
                            ZStack{
                                HStack{
                                    Text("Сохранить отчет:")
                                        .foregroundColor(Color.gray)
                                    Spacer()
                                }
                                HStack{
                                    Spacer()
                                    Toggle("", isOn: $saveReport)
                                }
                            }
                            if(saveReport){
                                HStack {
                                    VStack{
                                        HStack{
                                            Text("Название сохраняемого отчета:")
                                                .foregroundColor(Color.gray)
                                            Spacer()
                                        }
                                        TextField("Название", text: $newTitleSaveReport, prompt: Text("Название..."), axis: .vertical)
                                            .foregroundColor(.black)
                                            .lineLimit(1...2)
                                    }
                                }
                            }
                        }
                    } 
                }
                .padding(.top, 50)
                VStack{
                    Text("Создать отчет".uppercased())
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .frame(minWidth: 200)
                        .padding(EdgeInsets(top: 25, leading: 0, bottom: 10, trailing: 0))
                    Spacer()
                }
            }
            VStack{
                HStack{
                    Button{
                        clean()
                        hideKeyboard()
                    } label:{
                        Text("Очистить").foregroundColor(.black).padding().frame(width: 160)
                    }.background(Color(red: 0.949, green: 0.949, blue: 0.971))
                        .clipShape(Capsule())
                    
                    Button(action: {
                        if(!saveReport || newTitleSaveReport != ""){
                            if(reportViewModel.checkingYear(yearFromInReport: yearFromInReport, yearBeforeInReport: yearBeforeInReport)){
                                reportViewModel.getRecordsIncludedInReport(titleReport: newTitleReport, creatorReport: newCreatorReport, selectedRecordInReport: selectedRecordInReport, universityRecord: universityRecord, addSelectedRecord: addSelectedRecord, yearFromInReport: Int(yearFromInReport) ?? 0, yearBeforeInReport: Int(yearBeforeInReport) ?? 0)
                                showPdfReportWindow.toggle()
                                if(saveReport){
                                    reportViewModel.addReport(titleSaveReport: newTitleSaveReport, nameCreatedReport: newTitleReport, authorCreatedReport: newCreatorReport)
                                }
                            }
                            else{
                                alertTextCreateTitleError = "Ошибка"
                                alertTextCreateMessageError = "Указан неверный год публикаций."
                                showAlertCreateError.toggle()
                            }
                        }
                        else{
                            alertTextCreateTitleError = "Ошибка"
                            alertTextCreateMessageError = "Не указано название сохраняемого отчета."
                            showAlertCreateError.toggle()
                        }
                    }) {
                        HStack {
                            Text("Создать").foregroundColor(.black).padding().frame(width: 160)
                        }
                        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        .clipShape(Capsule())
                    }
                    .alert(isPresented: $showAlertCreateError) {
                        Alert(
                            title: Text(alertTextCreateTitleError),
                            message: Text(alertTextCreateMessageError),
                            dismissButton: .default(Text("Ок"))
                        )
                    }
                }
                .padding(.bottom, 40)
            }
            .sheet(isPresented: self.$showPdfReportWindow) {
                PdfPreviewView(recordsIncludedReport: reportViewModel.recordsInReport, newTitleReport: reportViewModel.titleReport, newCreatorReport: reportViewModel.creatorReport)
                    .environmentObject(reportViewModel)
            }
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
    }
     
    func clean(){
        newTitleReport = ""
        newCreatorReport = ""
        selectedRecordInReport = true
        universityRecord = false
        addSelectedRecord = false
        yearFromInReport = ""
        yearBeforeInReport = ""
        saveReport = false
        newTitleSaveReport = ""
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct CreateReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateReportView()
//    }
//}
