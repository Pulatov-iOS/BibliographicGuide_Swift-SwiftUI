//
//  DescriptionRecordPageView.swift
//  BibliographicGuide
//
//  Created by Alexander on 17.04.23.
//

import SwiftUI

struct DescriptionRecordPageView: View {
    
    @EnvironmentObject var recordListViewModel: RecordListViewModel
    var recordViewModel: RecordViewModel
    
    var body: some View {
        VStack{
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Spacer()
                    Text("Основная информация")
                        .font(.system(.title, design: .default))
                    Spacer()
                }
                
                VStack (alignment: .leading, spacing: 5) {
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Ключевые слова: " + recordListViewModel.getKeywordNameRecord(recordViewModel.record)) // не все
                            .font(.footnote)
                            .multilineTextAlignment(TextAlignment.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Divider()
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Авторы: " + recordViewModel.record.authors)
                            .font(.footnote)
                            .multilineTextAlignment(TextAlignment.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Divider()
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Год публикации: \(String(recordViewModel.record.year))")
                            .font(.footnote)
                            .multilineTextAlignment(TextAlignment.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Divider()
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Ссылка DOI: " + recordViewModel.record.linkDoi)
                            .font(.footnote)
                            .multilineTextAlignment(TextAlignment.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Divider()
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Название журнала: " + recordViewModel.record.journalName)
                            .font(.footnote)
                            .multilineTextAlignment(TextAlignment.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Divider()
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Номер журнала: " + recordViewModel.record.journalNumber)
                            .font(.footnote)
                            .multilineTextAlignment(TextAlignment.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Divider()
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        Text("Номера страниц: " + recordViewModel.record.pageNumbers)
                            .font(.footnote)
                            .multilineTextAlignment(TextAlignment.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Divider()
                    }
                    HStack (alignment: .top, spacing: 5) {
                        VStack{
                            Text("Ссылка: ")
                                .font(.footnote)
                                .multilineTextAlignment(TextAlignment.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        VStack{
                            Text(recordViewModel.record.linkWebsite)
                                .onTapGesture {
                                    UIApplication.shared.open(URL(string: recordViewModel.record.linkWebsite)!)
                                }
                                .foregroundColor(Color.blue)
                                .font(.footnote)
                                .multilineTextAlignment(TextAlignment.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color(UIColor.secondarySystemFill))
            )
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("Описание")
                        .font(.system(.title, design: .default))
                    Spacer()
                }
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 15, height: 25, alignment: .center)
                        .imageScale(.large)
                        .font(Font.title.weight(.ultraLight))
                        .foregroundColor(Color.gray)
                    Text(recordViewModel.record.description)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .font(.system(.body, design: .default))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 10)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color(UIColor.secondarySystemFill))
            )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
    }
}
//
//struct DescriptionRecordPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        DescriptionRecordPageView()
//    }
//}
