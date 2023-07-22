//
//  CreateReportView.swift
//  BibliographicGuide
//
//  Created by Alexander on 13.05.23.
//

import SwiftUI
import Combine

enum TypeReport: String, CaseIterable, Identifiable {
    case text
    case pdf
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .text:
            return ".text"
        case .pdf:
            return ".pdf"
        }
    }
}

struct CreateReportView: View {
    
    @EnvironmentObject var reportViewModel: ReportViewModel
    
    @State private var newTitleReport = ""
    @State private var newCreatorReport = ""
    @State private var listJournal = false
    @State private var selectedRecordInReport = true
    @State private var universityRecord = false
    @State private var addSelectedRecord = false
    
    @State private var yearFromInReport = ""
    @State private var yearBeforeInReport = ""
    
    @State private var typeReport: TypeReport = .pdf
    
    @State private var saveReport = false
    @State private var newTitleSaveReport = ""
    
    @State var showAlertCreateError: Bool = false
    @State var alertTextCreateTitleError: String = ""
    @State var alertTextCreateMessageError: String = ""
    
    @State private var showPdfReportWindow = false
    @State private var showTextReportWindow = false
    
    @State private var heightWindow = 0.0
    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
                        List{
                            Section(header: Spacer(minLength: 0)) {
                                if(typeReport.id.rawValue == "pdf"){
                                    HStack {
                                        VStack{
                                            HStack{
                                                Text("Название отчета:")
                                                    .foregroundColor(Color.gray)
                                                Spacer()
                                            }
                                            TextField("Название", text: $newTitleReport, prompt: Text("Название..."), axis: .vertical)
                                                .foregroundColor(.black)
                                                .lineLimit(2...2)
                                        }
                                    }
                                    HStack {
                                        Text("Создатель:")
                                            .foregroundColor(Color.gray)
                                        Spacer()
                                        TextField("Иванов А. А.", text: $newCreatorReport)
                                    }
                                }
                                else{
                                    VStack{
                                        ZStack{
                                            HStack{
                                                Text("Добавить список журналов:")
                                                    .foregroundColor(Color.gray)
                                                Spacer()
                                            }
                                            HStack{
                                                Spacer()
                                                Toggle("", isOn: $listJournal)
                                            }
                                        }
                                    }
                                }
                                HStack {
                                    Text("Формат отчета:")
                                        .foregroundColor(Color.gray)
                                    Spacer()
                                    HStack{
                                        Picker("Формат отчета", selection: $typeReport){
                                            ForEach(TypeReport.allCases){ typeReport in
                                                Text(typeReport.title).tag(typeReport)
                                            }
                                        }
                                        .pickerStyle(.segmented)
                                        .tint(.black)
                                        .onChange(of: typeReport){ Value in
                                            if(Value.id.rawValue == "pdf"){
                                                heightWindow += 2.2
                                            }
                                            else{
                                                heightWindow -= 2.2
                                            }
                                        }
                                    }
                                    .frame(width: 130)
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
                                                .onChange(of: selectedRecordInReport){ Value in
                                                    if(Value == true){
                                                        heightWindow -= 2
                                                    }
                                                    else{
                                                        heightWindow += 2
                                                    }
                                                }
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
                                                    .onChange(of: addSelectedRecord){ Value in
                                                        if(Value == true){
                                                            heightWindow += 1
                                                        }
                                                        else{
                                                            heightWindow -= 1
                                                        }
                                                    }
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
                                            .onChange(of: saveReport){ Value in
                                                if(Value == true){
                                                    heightWindow += 1.75
                                                }
                                                else{
                                                    heightWindow -= 1.75
                                                }
                                            }
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
                                            TextField("Название...", text: $newTitleSaveReport)
                                        }
                                    }
                                }
                            }
                        }
                        .scrollDisabled(true)
                        .frame(height: 375 + (43 * CGFloat(heightWindow)))
                            
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
                                            if(typeReport.id.rawValue == "pdf"){
                                                showPdfReportWindow.toggle()
                                            }
                                            else{
                                                showTextReportWindow.toggle()
                                            }
                                            if(saveReport){
                                                reportViewModel.addReport(titleSaveReport: newTitleSaveReport, typeReport: typeReport.id.rawValue, nameCreatedReport: newTitleReport, authorCreatedReport: newCreatorReport)
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
                        .sheet(isPresented: self.$showTextReportWindow) {
                            TextPreviewView(recordsIncludedReport: reportViewModel.recordsInReport, listJournal: listJournal)
                                .environmentObject(reportViewModel)
                        }
                    }
                }
                .padding(.top, 50)
                VStack{
                    HStack{
                        Spacer()
                        Text("Создать отчет".uppercased())
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 25, leading: 0, bottom: 5, trailing: 0))
                        Spacer()
                    }
                    .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                    Spacer()
                }
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
