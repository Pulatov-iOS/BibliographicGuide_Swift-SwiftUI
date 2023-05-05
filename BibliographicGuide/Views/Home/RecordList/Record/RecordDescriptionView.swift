//
//  RecordDescriptionView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI

struct RecordDescriptionView: View {
    
    var recordListViewModel: RecordListViewModel
    var recordViewModel: RecordViewModel
    @State var universityRecord = ""
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Image(systemName: "key.horizontal")
                    Image(systemName: "person.2")
                    Image(systemName: "clock")
                    Image(systemName: "text.book.closed")
                    Image(systemName: "building.2")
                }
                
                VStack{
                    HStack(alignment: .center) {
                        Text("Кл. слова: \(recordListViewModel.getKeywordNameRecord(recordViewModel.record))")
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack(alignment: .center) {
                        Text("Авторы: \(recordViewModel.record.authors)")
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack(alignment: .center) {
                        Text("Год: \(String(recordViewModel.record.year))")
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack(alignment: .center) {
                        Text("Журнал: \(recordViewModel.record.journalName)")
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack(alignment: .center) {
                        Text("Университета/кафедры: \(recordListViewModel.universityRecordToString(recordViewModel.record.universityRecord))")
                            .lineLimit(1)
                        Spacer()
                    }
                }
            }
        }
        .font(.footnote)
        .foregroundColor(Color.gray)
    }
}

//struct RecordDescriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordDescriptionView(recordDescriptionViewModel: RecordDescriptionViewModel(), record: Record(idUsers: [""], dateCreation: Date(),datesChange: [Date()], title: "", year: 1, keywords: "", authors: "", linkDoi: "", linkWebsite: "", journalName: "", journalNumber: "", pageNumbers: "", description: "", idPhotoTitle: "", idPhotoRecord: "", idPdfRecord: ""))
//    }
//}
