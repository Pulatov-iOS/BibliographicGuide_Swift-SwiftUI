//
//  RecordDescriptionView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI

struct RecordDescriptionView: View {
    
    @ObservedObject var recordDescriptionViewModel: RecordDescriptionViewModel
    var recordListViewModel: RecordListViewModel
    var recordViewModel: RecordViewModel
    
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 12) {
                HStack(alignment: .center){
                    
                    Image(systemName: "clock")
                    Text("Дата создания: \(recordDescriptionViewModel.checkingCreatingTime(recordViewModel.record.dateCreation ?? Date()))")
                        .padding(.trailing, 6)
                    Image(systemName: "pencil.line")
                    Text("Редакт: \(recordDescriptionViewModel.checkingEditingTime(recordViewModel.record.dateChange ?? Date()))")
                }
            }
            HStack(alignment: .center, spacing: 2, content: {
                
            })
        }
        .padding(.leading, 7)
        .font(.footnote)
        .foregroundColor(Color.gray)
    }
}

//struct RecordDescriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordDescriptionView(recordDescriptionViewModel: RecordDescriptionViewModel(), record: Record(idUsers: [""], dateCreation: Date(),datesChange: [Date()], title: "", year: 1, keywords: "", authors: "", linkDoi: "", linkWebsite: "", journalName: "", journalNumber: "", pageNumbers: "", description: "", idPhotoTitle: "", idPhotoRecord: "", idPdfRecord: ""))
//    }
//}
